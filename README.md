# Minimal Vesting Contract

### Vestoor.sol is a minimalistic, token agnostic and low footprint contract that provides immutable ERC20 token vesting functionality.  

________



[![tests](https://github.com/abigger87/femplate/actions/workflows/tests.yml/badge.svg)](https://github.com/abigger87/femplate/actions/workflows/tests.yml) [![lints](https://github.com/abigger87/femplate/actions/workflows/lints.yml/badge.svg)](https://github.com/abigger87/femplate/actions/workflows/lints.yml) ![GitHub](https://img.shields.io/github/license/abigger87/femplate) 

## How It Works

The contract has two state-altering functions. One that creates a 'vesting' and one that allows the beneficiary to withdraw already vested amounts. The 'vesting' is continous, meaning it starts at the moment when it is created so that the beneficiary is eligible to withdraw from the agreement proportionally with the elapsed time. <i> <b> Example</b>: I 'vest' you 100 tokens, over 100 days. 1 day after the creation of the 'vesting', you will be able to withdraw 1 token. </i>


### Storage
For time-dependent access to token ownership there's a few variables that a vesting system needs to be mindful of at a minimum. First, it needs to be able to tell time. Secondly, it needs to store: the beneficiary, the token used, a fullfillment date and an amount. <br>

All of this is store in one nested mapping. <br>
<code> mapping(address => mapping(address => uint256)) vestings; </code> <br>
Storing, retrieving and updating vesting data is done through <br>`vestings[vested token contract address][address of beneficiary] = uint256` 

#### Formula

[token][beleficiary] = amountOfTokens (amount < k) * k (constant) + endTime (seconds unix epoch [days_arg * 1 days + block.timestamp])

#### Limitations

* One beneficiary address can have only one 'vesting' per token
* Immutable. No refunds, rugpulls, mending
* The max amount is < uint128 

## Getting Started
Clone, then forge install.

Update and rename .env.example or add the listed variables to global session. First time using foundry and this template. You get the point.

``` forge install ``` <br>
``` forge test ```


## Disclaimer

_These smart contracts are being provided as is. No guarantee, representation or warranty is being made, express or implied, as to the safety or correctness of the user interface or the smart contracts. They have not been audited and as such there can be no assurance they will work as intended, and users may experience delays, failures, errors, omissions, loss of transmitted information or loss of funds. The creators are not liable for any of the foregoing. Users should proceed with caution and use at their own risk._
