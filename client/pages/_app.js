import '../styles/globals.css'
import { MoralisProvider } from 'react-moralis'


function MyApp({ Component, pageProps }) {
  

  const appId = process.env.NEXT_PUBLIC_MORALIS_APPLICATION_ID
  const serverUrl = process.env.NEXT_PUBLIC_MORALIS_SERVER_URL

  
  return (
  <MoralisProvider appId={appId} serverUrl={serverUrl}>
   <Component {...pageProps} />
  </MoralisProvider>
  )
}

export default MyApp
