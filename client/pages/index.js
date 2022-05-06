import Head from 'next/head'

import styles from '../styles/Home.module.css'
import Header from '../components/Header'
import {Row, Col}  from 'web3uikit'


export default function Home() {
  return (
    <div className={styles.container}>
      
      <Row>
      <Header />
      </Row>
      
      <Row>
      <Col>
        <h1>Hello Next.js</h1>
      </Col>
      </Row>
       
      
    </div>
  )
}
