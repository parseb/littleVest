/* Moralis init code */
const serverUrl = 
const appId = 
//const Moralis = require("moralis");
MMM = Moralis.start({ serverUrl, appId, web3Library: Web3 });


const loginbutton = document.getElementById("btn-login");
const logoutbutton = document.getElementById("btn-logout");
const vestToken = document.getElementById("vesting-token");

// const btnapprove = document.getElementById("btn-approve");
// const btnmint = document.getElementById("btn-mint");

const mainbodyLogged = document.getElementById("mainbody");
const description = document.getElementById("description");
const ypamount = document.getElementById("yp-amount");
const ypsymbol = document.getElementById("yp-symbol");
const vestdays = document.getElementById("vest-days-amount");
const beneficiary = document.getElementById("beneficiary");




let placeholder = {
  chainId: '0x13881',
  user: null,
  token: null,
  littleVestAddress: {
    '0x13881': '0x2272B955E9828acBA482133Dd634493Ff2aEfD4b',
  }
}





document.addEventListener("DOMContentLoaded", async function() { 
 const user= await Moralis.User.current(); 

 
   if(user === null || typeof(user) === 'undefined') {
     nouser();

   } else {
     placeholder.user= user.attributes.ethAddress;
     placeholder.chainId =  await Moralis.getChainId();
     isuser(user);
   }

  });

   
/* Authentication code */
async function login() {
  let user = Moralis.User.current();
  if (!user) {
    user = await Moralis.authenticate({
      signingMessage: "Log in using Moralis",
    })
      .then(function (user) {
        console.log("logged in user:", user);
        console.log(user.get("ethAddress"));
      })
      .catch(function (error) {
        console.log(error);
      });
  }
}

async function login() {
  let user = Moralis.User.current();

  if (!user) {
   try {
      user = await Moralis.authenticate({ signingMessage: "Little Vest Authentication" })
      console.log(user.get('ethAddress'))
      placeholder.user = user.get('ethAddress');
      isuser(user);

   } catch(error) {
     console.log(error)
   }
  }
  
}


async function logOut() {
  await Moralis.User.logOut();
  console.log("logged out");
  nouser();
}


function nouser() {
  loginbutton.classList.remove("d-none");
  loginbutton.classList.add("d-block");
  logoutbutton.classList.remove("d-block");
  logoutbutton.classList.add("d-none");

  description.classList.remove("d-none");
  mainbodyLogged.classList.add("d-none");

}

async function isuser(u) {
  logoutbutton.classList.remove("d-none");
  logoutbutton.classList.add("d-block");
  loginbutton.classList.remove("d-block");
  loginbutton.classList.add("d-none"); 

  mainbodyLogged.classList.remove("d-none");
  description.classList.add("d-none");
  //btnapprove.classList.remove("d-none");

  const userAddress = await Moralis.User.current().attributes.ethAddress;
  await getUserData(u).then((vests) => { 
    console.log(vests);

  });



}

async function getAllIds(){
  const allIdOptions = {
    address: placeholder.littleVestAddress[window.ethereum.chainId],
    chain: window.ethereum.chainId,
  };

  const nftIds = await Moralis.Web3API.token.getAllTokenIds(allIdOptions);

  return nftIds;
}


async function getUserData(_user) {
  const vests = [];

  const tokenContractOptions = {
    chain: window.ethereum.chainId,
    address: placeholder.littleVestAddress[window.ethereum.chainId],
    function_name: "getVestDataFromId",
    abi: LVabi,
    params: {_tokenId: '0'},
  };


  const ids = await getAllIds();
  for (let i = 0; i < ids.length; i++) {
    element = ids[i];
    console.log("elelement", element);
    tokenContractOptions.params._tokenId = element.token_id;
    const d = await Moralis.Web3API.native.runContractFunction(tokenContractOptions);
    console.log("d", d);
    vests.append(d);

  }
  return vests;
}



async function ypContractAddressChanged() {
  setToken();
  fetchUpdateCreateForm();
}

const vestingToken = document.getElementById("vesting-token");

async function getYApproved(userAddress) {
  let yp = vestToken.value;


  const tokenContractOptions = {
    chain: 'mumbai',
    address: vestToken.value,
    function_name: "allowance",
    abi: ERC20Abi,
    params: { _owner: placeholder.user, _spender: placeholder.littleVestAddress[window.ethereum.chainId] },
  };

  const allowance = await Moralis.Web3API.native.runContractFunction(tokenContractOptions);

  ypApproved = allowance;
  console.log("ypApproved", allowance);
  placeholder.ypApproved = allowance;
  return ypApproved;  
}

async function setToken() {
  let token = vestToken.value;
  const options = {
    chain: 'mumbai',
    addresses: token,
  };

  const tokenMetadata = await Moralis.Web3API.token.getTokenMetadata(options);

  let tokenName = tokenMetadata[0].name;
  placeholder.tokenAddress = vestToken.value;
  placeholder.token = tokenMetadata;
  // hardcoded
  ypsymbol.innerHTML = `<a href="https://mumbai.polygonscan.com/address/${placeholder.token[0].address}" target="_blank" class="text-decoration-none">${tokenMetadata[0].name}</a>`;

}


async function fetchUpdateCreateForm() {
  if (ypamount.value !=  placeholder.ypApproved) {
    let ypapproved = document.getElementById("yp-approved");
    console.log('this is placeholder.user', placeholder.user);
    getYApproved(placeholder.user).then( (amount) => {
      ypapproved.placeholder = `approved: ${amount}`;
      console.log("approved amount", amount,"ypa", ypamount.value);
      if (parseInt(amount) >= parseInt(ypamount.value)) {
      ypapproved.classList.replace("text-danger", "text-success"); 
    } else {
      ypapproved.innerText = `allowance: ${amount}`;
      ypapproved.classList.replace("text-success","text-danger"); 
    }
    })
  }
} 

async function erc20AmountChanged() {
  placeholder.ypAmount = ypamount.value;
  console.log("amount chaged: ", placeholder.ypAmount); 
  fetchUpdateCreateForm();

}

async function createV() {
  console.log("create vest");
  t1 = vestToken.value;
  b2 = beneficiary.value;
  amount3 = ypamount.value;
  days4 = vestdays.value;
  console.log(t1, b2, amount3, days4);

  const ethers = Moralis.web3Library;
  const contract = new ethers.Contract(t1, LVabi, Moralis.provider);

  m = await Moralis.enableWeb3();

  const tokenContractOptions = {
    contractAddress:  placeholder.littleVestAddress[window.ethereum.chainId],
    functionName: "setVest",
    abi: LVabi,
    provider: m,
    params: {_token: t1, _beneficiary: b2, _amount: amount3, _days: days4},
  };
  
  const tx = await Moralis.executeFunction(tokenContractOptions);

}


loginbutton.onclick = this.login;
logoutbutton.onclick = this.logOut;
