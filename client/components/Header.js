import { ConnectButton } from "web3uikit";


export default function Header() {
    return(
        <div className="container">
                    <nav className="p-5 border-b-2 flex flex-row">
            <h1 className="py-4 px-4 font-bold text-3xl">
                Little Vest
            </h1>
            <div className="ml-auto py-2 px-4">
                <ConnectButton moralisAuth={true}/>
            </div>
        </nav>

        <div className="flex flex-row">
            <h3>textttt abcdefghijklmnopq</h3>    
        </div>
        </div>

    )
}