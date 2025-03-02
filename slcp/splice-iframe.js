/*

  API:

  SPLICE.reportScoreAndState(location, score, state)

  location: a unique ID in the document
  score: a number between 0 and 1,
  state: arbitrary state data that the element saves and retrieves in
  order to restore student work.

  SPLICE.getState(location, callback)

  Upon retrieval, invokes callback(state, error)

  SPLICE.sendEvent(location, name, data)

  Message Protocol:

  Request from child to parent

  { subject: 'lti.frameResize', height: ... } }
  No response

  { subject: 'SPLICE.reportScoreAndState',
  score: a composite score between 0 and 1
  state: { location1: ..., location2: ..., ... }}
  No response

  { subject: 'SPLICE.getState', message_id: ... }
  Response: { subject: 'SPLICE.getState.response', message_id: ..., state: { location1: ..., location2: ..., ... }}

  { subject: 'SPLICE.sendEvent',
  name: event name,
  data: event data }
  No response

*/

/* global MutationObserver */ // https://github.com/standard/standard/issues/1159
/* global performance */

if (window.self !== window.top) { // iframe
  window.addEventListener('load', event => {
    const scores = {}
    const states = {}
    let callbacks = []
    let docHeight = 0
    let docWidth = 0
    let config = {}

    function sendDocHeight () {
      if (window.self === window.top) return // not iframe

      const SEND_DOCHEIGHT_DELAY = 100
      setTimeout(() => {
        const newDocHeight = document.documentElement.scrollHeight + document.documentElement.offsetTop
        const newDocWidth = document.documentElement.scrollWidth + document.documentElement.offsetLeft
        if (docHeight !== newDocHeight || docWidth !== newDocWidth) {
          docHeight = newDocHeight
          docWidth = newDocWidth
          const data = { subject: 'lti.frameResize', message_id: generateUUID(), height: docHeight, width: docWidth }
          window.parent.postMessage(data, '*')
          if (window.SPLICE.logging) console.log('postMessage to parent', data)
        }
      }, SEND_DOCHEIGHT_DELAY)
    }

    // https://stackoverflow.com/questions/105034/create-guid-uuid-in-javascript
    function generateUUID () { // Public Domain/MIT
      let d = new Date().getTime()
      let d2 = (performance && performance.now && (performance.now() * 1000)) || 0 // Time in microseconds since page-load or 0 if unsupported
      return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, c => {
        let r = Math.random() * 16 // random number between 0 and 16
        if (d > 0) { // Use timestamp until depleted
          r = (d + r) % 16 | 0
          d = Math.floor(d / 16)
        } else { // Use microseconds since page-load if supported
          r = (d2 + r) % 16 | 0
          d2 = Math.floor(d2 / 16)
        }
        return (c === 'x' ? r : (r & 0x3 | 0x8)).toString(16)
      })
    }

    if (!('SPLICE' in window)) {
      window.SPLICE = {
        logging: false,
        getState: (location, callback) => {
          if (callbacks === undefined) {
            callback(states[location])
          } else {
            if (callbacks.length === 0) {
              // first call to getState, get it from parent
              const message = { subject: 'SPLICE.getState', message_id: generateUUID() }
              if (config.domain_id !== undefined) message.domain_id = config.domain_id;
              if (config.content_id !== undefined) message.content_id = config.content_id;
              window.parent.postMessage(message, '*')
              if (window.SPLICE.logging) console.log('postMessage to parent', message)
              const MESSAGE_TIMEOUT = 15000
              setTimeout(() => {
                if (callbacks === undefined) return
                for (const { location, callback } of callbacks) {
                  scores[location] = 0
                  states[location] = undefined
                  callback(undefined, { code: 'timeout' })
                }
                callbacks = undefined
              }, MESSAGE_TIMEOUT)
            }
            callbacks.push({ location, callback })
          }
        },
        reportScoreAndState: (location, score, state) => {
          scores[location] = score
          states[location] = state
          if (window.self === window.top) return // not iframe
          let averageScore = 0
          let n = 0
          for (const location in scores) {
            averageScore += scores[location]
            n += config?.weights?.[location] ?? 1
          }
          if (n > 0) averageScore /= n
          const message = { subject: 'SPLICE.reportScoreAndState', message_id: generateUUID(), score: averageScore, state: states }
          window.parent.postMessage(message, '*')
          if (window.SPLICE.logging) console.log('postMessage to parent', message)
        },
        sendEvent: (location, name, data) => {
          const message = { subject: 'SPLICE.sendEvent', message_id: generateUUID(), location, name, data }
          window.parent.postMessage(message, '*')
          if (window.SPLICE.logging) console.log('postMessage to parent', message)
        },
        configure: (params) => {
          config = params
        }
      }
    }

    window.addEventListener('message', event => {
      if (typeof event.data !== 'object') return
      if (typeof event.data.subject !== 'string') return
      if (!event.data.subject.startsWith('SPLICE.')) return
      if (event.data.subject.endsWith('response')) {
        if (window.SPLICE.logging) console.log('postmessage response', event.data)
        if (event.data.subject === 'SPLICE.getState.response') {
          if (callbacks === undefined) return // Already timed out
          for (const location in event.data.state) {
            scores[location] = 0
            states[location] = event.data.state[location]
          }

          for (const { location, callback } of callbacks) {
            callback(states[location], event.data.error)
          }
          callbacks = undefined
        }
        // Handle other responses
      }
      // TODO: SPLICE messages from children
    }, false)

    sendDocHeight()
    document.body.style.overflow = 'hidden'
    // ResizeObserver did not work
    const mutationObserver = new MutationObserver(sendDocHeight)
    mutationObserver.observe(document.body, { childList: true, subtree: true })
  })
}
