〈html  
  〈head  
    〈title SPLICE Working Group: Smart Learning Content Protocols〉 
    〈meta http-equiv=content-type content='text/html; charset=UTF-8'〉
    〈link rel=stylesheet href=../cssplice.css type=text/css〉 
  〉 
  〈body  
    〈div#content  
      〈h1 SPLICE iframe Protocol: Specification〉
      〈p If you read this as the implementer of a learning system that embeds smart learning content as iframes, you only need to care about the message protocol. You may find 〈a href=splice-parent.js this starter code〉 helpful.〉  
      〈p If you read this as the implementer of smart learning content, which you would like to make available to learning systems, you may want to make use of 〈a href=splice-iframe this reference implementation〉 that provides a friendly JavaScript interface for the message protocol.〉



      〈h2 Messages〉
      〈p These messages are supported:
〉
      〈h3 The reportScoreAndState Message〉
      〈p The smart learning content sends this message whenever the activity’s state and/or score changes.〉
      〈pre
{ 
   subject: 'SPLICE.reportScoreAndState', 
   message_id: a unique string ID for this message,
   score: a floating-point number between 0 and 1
   state: an arbitrary JavaScript object
}〉
      〈p The learning system should update the user’s score and optionally store the state.〉
      〈h3 The getState Message〉
      〈pre
{ 
   subject: 'SPLICE.getState', 
   message_id: a unique string ID for this message,
   domain_id: an optional globally unique domain chosen by the content provider,
   content_id: an optional unique ID in the domain,
}
〉
      〈p If the 〈 domain_id〉 is not specified, it is implied to be the host domain that serves the iframe of this activity. If the 〈 content_id〉 is not specified, it is implied to be the part of the iframe URL after the scheme, host, and port. 〉
      〈p 
Use these IDs if you want to provide an identifier for the smart learning content that is more canonical than the iframe URL.〉
      〈p 
The 〈 getState〉 message has a response:
〉
      
      〈pre
{
    subject: "SPLICE.getState.response",
    message_id: the same ID as the request,
    state: the previously reported state,
    user_id: an optional unique and opaque user ID    
}
〉
      〈p If you do not support state restoration, reply to the 〈 getState〉 message with a state of 〈 null〉.〉〈p 
The response may contain more information about the user that the smart learning content can interpret, such as their prior skill level. This information is not currently standardized.〉〈p 
If there is an error in the request, the response must contain, with key 〈 error〉, a JavaScript object 
〉
      
      〈pre
{
    code: a text string with an error code
    message: optionally, a text string with a humanly readable message
}
〉
      〈p NOTE: We don’t use the lti.get_data, lti.put_data message from LTI for state storage because those data are described to be “short lived”〉
      〈h3 The sendEvent Message〉
      〈p 
This message informs about interactions with the smart learning content that are unrelated to scoring and state restoration. The learning system may choose to log or store them, and to make them available to interested parties, such as education researchers. The message content is not currently standardized. 
〉
      
      〈pre
{ 
   subject: 'SPLICE.sendEvent', 
   message_id: a unique string ID for this message,
   name: ...,
   data: ...
}
〉

      〈h3 The lti.frameResize Message〉
      〈p The embedded iframe sends this message whenever its size changes. This allows the embedding page to display the iframe without scroll bars.
〉
      〈pre
{ 
   subject: lti.frameResize', 
   message_id: a unique string ID for this message,
   height: ...,
   width: ... 
}
〉
      〈h2 Protocol Implementation Notes〉

      〈p If you implement a smart learning system that embeds iframes with smart learning content, you need to be aware of a couple of issues with iframe communication. 〉〈p 
When receiving a message from an iframe, and if you have more than one, you want to know which iframe sent it. Unfortunately, you cannot do the obvious and consult 〈 event.source.location.href〉. That’s a CORS violation. Instead, use code similar to the following:
〉
      
      〈pre
function sendingIframe(event) {
  for (const f of document.getElementsByTagName('iframe'))
  if (f.contentWindow === event.source) return f
  return undefined
}

window.addEventListener("message", event => {
  let iframe = sendingIframe(event)
  let url = iframe.src
  . . .
})

〉
      〈p 
When sending a message to an iframe, use
〉

      
      〈pre
event.source.postMessage({
  message_id: event.data.message_id,
  subject: "SPLICE.getState.response",
  state: state,
}, "*");

〉
      〈p with a "*" for the 〈a href=https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage#targetorigin targetOrigin〉 parameter. Otherwise your message may not be delivered: 
〉〈p Listen to the lti.frameResize messages and adjust the size of the iframe, using code such as the following:
〉
      
      〈pre
Let newHeight = event.data.height
if ('chrome' in window) {
  const CHROME_FUDGE = 32 // to prevent scroll bars in Chrome
  newHeight += CHROME_FUDGE
}
if (iframe.scrollHeight < newHeight)
  iframe.style.height = newHeight + 'px'
〉
      〈h2 JavaScript Reference Implementation〉
〈p This section is addressed to authors of smart learning content, served as an HTML page, ready for inclusion as an iframe. 
〉〈p A 〈a href=splice-iframe.js reference implementation〉 provides a simple JavaScript API that is easier to use than sending and receiving messages. You can use the JavaScript code as is, modify it for your situation, or provide your own messaging code.
〉〈p The implementation supports multiple interactive elements on the page. Each of them has a location ID, which must be unique to the page. If you only have one element, simply provide an empty string as the ID.
〉〈p The following calls are provided:
〉
〈pre
SPLICE.reportScoreAndState(location, score, state)
SPLICE.getState(location, callback)
SPLICE.sendEvent(location, name, data)
SPLICE.configure(params)
〉
      〈ul

〈li location: an ID string for the activity that is unique to this page. 〉
〈li score: a floating-point number between 0 and 1〉
〈li state:  an arbitrary JavaScript object〉
〈li callback: a function that is called with parameters location and state〉
〈li name: the event name〉
〈li data: an arbitrary JavaScript object〉
〈li params: a JavaScript object that is described below〉

      〉

      〈p Call 〈 SPLICE.reportScoreAndState〉 whenever an activity’s score changes. 
〉〈p If restoration of student work from a prior launch is desired, provide state information in each call to 〈 SPLICE.reportScoreAndState〉. 
〉〈p Call the 〈 SPLICE.getScores〉 method when loading the page to retrieve the state information. Not all learning systems have the ability to save and restore state, so be prepared that this call may yield no information, or it may not even return. Call this method even if you are not interested in getting scores, to notify the learning system that your element is ready. 
〉
      〈p Optionally call 〈 SPLICE.configure〉 before making any other calls. You can specify the following parameters:〉
      〈ul
〈li 〈 domain_id〉: an optional globally unique domain chosen by the content provider〉
〈li 〈 content_id〉: an optional unique ID in the domain,〉
〈li 〈 weights〉: a map from locations to weights, for combining the scores of each location 〉
      〉

      〈p The reference implementation emits 〈 lti.frameResize〉 messages when the document size changes.〉
      〈p NOTE: We may want to standardize this API at some point in the future. Then we might want to replace the 〈 SPLICE〉 identifier with something like 〈 org.cssplice.content〉. 
〉
    〉 
    〈div#footer  
      〈hr〉 
      〈p.footertext  〈a href=mailto:cssplice@gmail.com Contact us〉 〉 
      〈p.footertext  Last updated: 
        〈script type=text/javascript
          document.write(document.lastModified);
        〉 
      〉 
    〉 
  〉 
〉
