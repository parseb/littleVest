/* Moralis init code */
const serverUrl = "https://b4qeudq10dzf.usemoralis.com:2053/server";
const appId = "M09MS9RQCHWihvFmxpCuJSs0U48N5xzIWeoNWK9U";
//const Moralis = require("moralis");
Moralis.start({ serverUrl, appId });


const loginbutton = document.getElementById("btn-login");
const logoutbutton = document.getElementById("btn-logout");

// const btnapprove = document.getElementById("btn-approve");
// const btnmint = document.getElementById("btn-mint");

const mainbodyLogged = document.getElementById("mainbody");
const description = document.getElementById("description");

let placeholder = {
  user: {}
}





document.addEventListener("DOMContentLoaded", async function() { 
 const user= await Moralis.User.current(); 

 
   if(user === null || typeof(user) === 'undefined') {
     nouser();
   } else {
     placeholder.user= user.attributes.ethAddress;
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
  await getUserData(u).then((vests) => { console.log(vests) });
}


async function getUserData(_user) {
  
}



loginbutton.onclick = this.login;
logoutbutton.onclick = this.logOut;
