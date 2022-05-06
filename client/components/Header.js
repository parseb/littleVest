import { ConnectButton } from "web3uikit";
import  Image  from "next/image";

export default function Header() {
    return(
        <div className="container">
        <nav className="p-5 border-b-2 flex flex-row">
            
            <div className="ml-auto py-2 float-left">
                <img src="logo.png" alt="logo" className="h-20 float-left" />
            </div>
                
       
            <div className="ml-auto py-2 px-4">
                <ConnectButton moralisAuth={true}/>
            </div>
        </nav>
        </div>

    )
}