window.addEventListener('DOMContentLoaded', () => {
  function sendingIframe(event) {
    for (const f of document.getElementsByTagName('iframe'))
      if (f.contentWindow === event.source) return f
    return undefined
  }

  function adjustDocHeight(iframe, newHeight) {
    if (iframe.scrollHeight < newHeight)
      iframe.style.height = newHeight + 'px'
  }

  window.addEventListener("message", event => {
    let iframe = sendingIframe(event)
    console.log(iframe.src, event.data)
    if (event.data.subject === 'lti.frameResize')
      adjustDocHeight(iframe, event.data.height)
    else if (event.data.subject === 'SPLICE.reportScoreAndState') {
      // sendScoreAndState(iframe, event.data.score)
    }
    else if (event.data.subject === 'SPLICE.getState') {
      const state = null // getStateOfProblem(iframe)
      iframe.contentWindow.postMessage({ subject: 'SPLICE.getState.response', message_id: event.data.message_id, state }, '*')      
      }
  }, false);
})
