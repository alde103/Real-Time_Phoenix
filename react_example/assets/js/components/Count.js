import React, { useContext, useEffect, useState } from 'react'
import { PingChannelContext } from '../contexts/PingChannel'

export default function Count() {
  const [count, setCount] = useState(0)
  const { onPing } = useContext(PingChannelContext)

  useEffect(() => {
    const teardown = onPing((data) => {
      console.debug('Count pingReceived', data)
      setCount((count) => count + 1)
    })

    return teardown
  }, [])

  return (
    <div>
      <h2>Counter</h2>

      <p>
        This page displays the number of received messages, since this page was mounted.
      </p>

      <strong>{count}</strong>
    </div>
  )
}
