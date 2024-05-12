import React, { useContext, useEffect, useState } from 'react'
import { PingChannelContext } from '../contexts/PingChannel'

export default function Pings(props) {
  const topic = props.topic || 'ping'
  const [messages, setMessages] = useState([])
  const { onPing, sendPing } = useContext(PingChannelContext) 

  const appendDataToMessages = (data) =>
    setMessages((messages) => [ 
      JSON.stringify(data),
      ...messages
    ])

  useEffect(() => {
    const teardown = onPing((data) => { 
      console.debug('Pings pingReceived', data)
      appendDataToMessages(data)
    })

    return teardown 
  }, [])

  return (
    <div>
      <h2>Pings: {topic}</h2>

      <p>
        This page displays the PING messages received from the
        server, since this page was mounted. The topic
        for this Channel is {topic}.
      </p>

      <button onClick={
        () => sendPing(appendDataToMessages)
      }>Press to send a ping</button>

      <textarea value={messages.join('\n')} readOnly />
    </div>
  )
}
