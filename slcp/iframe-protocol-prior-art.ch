〈html  
  〈head  
    〈title SPLICE Working Group: Smart Learning Content Protocols〉 
    〈meta http-equiv=content-type content='text/html; charset=UTF-8'〉
    〈link rel=stylesheet href=../cssplice.css type=text/css〉 
  〉 
  〈body  
    〈div#content  
      〈h1 SPLICE iframe Protocol: Prior Art〉



〈p The following sections enumerate known JavaScript APIs and postMessage protocols in existing systems.
〉
      〈p TLDR; There are three takeaways:〉
      〈ol 〈li Two JavaScript calls suffice, to send and receive scores and state〉
〈li One needs an iframe message for each of these calls, and another to inform the parent about size changes〉
〈li To nobody’s surprise, everyone’s implementation has minor naming differences〉
〉
      〈h2 EPUB for Education〉
〈p A proposed 〈a href=https://idpf.org/epub/profiles/edu/spec/#h.dxf1o3gw16x0 EPUB for Education〉 standard contains a JavaScript API for sending score and state to an EPUB reading system, and for retrieving previously sent scores and state:〉
〈pre
EPUB.Education.reportScores([scores], callback)
EPUB.Education.getScores([location], callback)〉
〈p Each scores object has the form〉
〈pre { 
   score: number,
   location: string,
   metadata: { /* arbitrary element-specific state */ }
}
〉
      〈p When scores are retrieved, the callback function is called with an array of
〉〈pre { 
   score: number,
   location: string,
   timestamp: UTCTimeStamp,
   metadata: { ... }
}〉
〈h2 VitalSource〉
〈p VitalSource provides an EPUB reading system that is used by prominent textbook publishers including Pearson and Wiley. That reading system implements an earlier version of the EPUB for Education API, where the score information also contained:〉
〈ul 〈li A client-side creation timestamp〉
〈li A progress percentage〉
〈li A success flag to indicate completion〉
〈li A response string (in addition to the state metadata)〉
〉
      〈p VitalSource participated in the EPUB for Education process and presumably found these items unnecessary as standardization progressed.〉
〈h2 LTI Client Side postMessages〉
〈p IMS Global has a 〈a href=https://www.imsglobal.org/spec/lti-cs-pm/v0p1 proposal〉, at version 0.1 as of October 17, 2022, for messaging between an iframe containing smart learning content and its parent in the learning platform. 〉
〈p Request structure:〉
〈pre {
  "subject": "lti.example",
  "message_id": "12345",
  …
}〉
〈p Response structure: 〉
〈pre {
  "subject": "lti.example.response",
  "message_id": "12345",
  …
}
〈p 〉Error responses have the format〉
〈pre {
  "subject": "lti.example.response",
  "message_id": "12345",
  "error": {
    "code": "bad_request",
    "message": "A specific useful error message"
  }
}
〉
      〈p Defined services include:〉
〈ul 〈li Enumeration of available services (lti.capabilities)〉
〈li 〈a href=https://www.imsglobal.org/spec/lti-pm-s/v0p1 Storage and retrieval of keyed strings〉 (lti.put_data, lti.get_data)〉
〉
      〈h2 lti_messaging〉
〈p The 〈a href=https://canvas.instructure.com/doc/api/file.lti_window_post_message.html Canvas LMS〉 and 〈a href=https://github.com/bracken/lti_messaging others〉 implement a postMessage protocol that is an extension of the preceding proposal. In addition to the capabilities and put_data/get_data messages, there are messages for window sizing and scrolling, alerts, and managing parts of the ambient Canvas UI.〉
〈h2 Acos〉
〈p The 〈a href=https://github.com/acos-server/acos-server Acos server〉 distributes smart learning content to learning management systems using different protocols. 〉
〈p Content can 〈a href=https://github.com/acos-server/acos-server/blob/master/doc/development.md#events send events〉 by calling 〉
〈pre ACOS.sendEvent(eventName, payload, callback)〉
〈p Two events are defined with names grade and log. The grade event sends an object〉
〈pre {
  points: …,
  max_points: …
}
〉
      〈p The log event can send any JSON object.〉
〈p Events are sent with HTTP POST, not postMessage.〉
〈p The Acos server does not support saving and restoring state.〉
〈h2 TODO: edX XBlock〉
〈p 〈a href=https://edx.readthedocs.io/projects/xblock-tutorial/en/latest/overview/introduction.html〉〉
〈p 〈a href=https://edx.readthedocs.io/projects/xblock-tutorial/en/latest/concepts/events.html〉〉
〈pre self.runtime.publish(self, "grade",
                    { value: submission_result
                      max_value: 1.0 })
〉
〈h2 JSAV〉
〈p The 〈a href=https://opendsa.cs.vt.edu/ OpenDSA textbooks〉 contain smart learning content in iframes, such as 〈a href=http://jsav.io/ JSAV〉 instances. JSAV is a library for authoring interactive exercises involving data structures such as graphs, trees, and linked lists. 
JSAV has a 〈a href=http://jsav.io/otherapis/logging/ 〈 logEvent〉〉 method that can be configured to send messages to the parent frame. Here is a typical message:〉
〈pre { 
   type: "jsav-exercise-step-fixed", 
   tstamp: "2023-03-20T17:53:37.325Z", 
   av: "DijkstraPE",
   currentStep: 2,
   desc: { score: 0, complete: 0.17 },
   ​​score: { total: 6, correct: 0, undo: 0, fix: 1, student: 0 },
   seed: "580379635345",
   totalTime: 576179,
   tstamp: "2023-03-20T17:53:37.325Z",
   uiid: 1679334241146
}〉
〈h2 Codio〉
〈p Codio is a system for delivering interactive computing courses. It has an internal API for smart learning content with these calls:〉
      〈pre
codio.assessments.send(iid, state, result)
codio.assessments.get(iid, callback)〉
〈p Here, 〈 state〉 is an arbitrary object, and 〈 result〉 a number between 0 and 100. The callback is invoked with an error or 〈 { answer: state }〉.〉
〈h2 zyBooks〉
〈p Zybooks has an IframeWithApi tool that includes an iframe into a book. The iframe is expected to use the 〈a href=https://github.com/Aaronius/penpal PenPal〉 library and make these three calls:〉
〈pre parent.submit(score, state)
state = await parent.getState()
parent.resize(docHeight, docWidth)
〉
      〈h2 CodeCheck Assignments〉
〈p The 〈a href=http://horstmann.com/codecheck/assignments.html CodeCheck Assignments〉 system used to have a proprietary JavaScript API and postMessage API for aggregating content into LTI assignments. It now uses the SPLICE content protocol.〉
〈p The JavaScript API:〉
〈pre horstmann_config.score_change_listener(element, state, score)
horstmann_config.retrieve_state = function(element, callback)〉
〈ul 〈li 〈 element〉 is the root DOM element of the activity, which must have an id〉
〈li 〈 state〉 is an arbitrary object〉
〈li 〈 score〉 is a number between 0.0 and 1.0〉〉
〈p Upon successful retrieval, 〈 callback(element, state)〉 is invoked.〉
〈p The postMessage format had three query types:〉
〈pre { query: 'docHeight', param: { docHeight: ... }}
{ query: 'send', param: { id: ..., state: ..., score: ... }} 
{ query: 'retrieve', param: { id: ... }, nonce }〉
〈p The first two queries have no response. The 〈 retrieve〉 query returns 〈 { request: /* the entire request */, param: state }〉〉
〈h2 PAWS Cumulate-Adapt2 Protocol〉
〈p CUMULATE (Centralized User Modeling Architecture for TEaching) collects evidence (events) about student learning from multiple applications. CUMULATE supports a protocol that allows external applications to send learner interaction events for student modeling purposes. In short, to report student activity, the external application should indicate what learning object the student (user) is working on, who the student is, and what the outcome of this interaction is (success/failure). 
〉
      〈p External applications send the interaction logs using HTTP GET requests to the CUMULATE’s report servlet using the following URL format:〉
〈pre http://<server>?app=<application>&act=<learning_object>&sub=<learning_object_step>
&usr=<learner>&grp=<group>&sid=<session_id>&res=<result>&svc=<service_parameters>〉

      〈ul 〈li app – application id denoting the application that the student is working with (required)〉
〈li act – learning object, the student is working with (required)〉
〈li sub – the step of the learning object (mandatory/optional depending on application)〉
〈li usr – student id whose activity is reported (mandatory)〉
〈li grp – group or class or section that student belongs to (mandatory)〉
〈li sid – session id, a token of up to 5 characters (mandatory)〉
〈li res – result of the interaction, 0 if unsuccessful, 1 if successful, or any value in between in case of partial success, -1 is reserved for "no credit" activities such as viewing a worked example (mandatory)〉
〈li svc – an arbitrary string the application might want to store for later (e.g. capturing context), not parsed by user modeling server (optional)〉
〉
      〈p Example request URL:〉
〈pre http://adapt2.sis.pitt.edu/cbum/um?app=3&act=helloworld.c&sub=12&usr=myudelson&grp=200721&sid=FD34A&res=1&svc=adaptive_link〉
〈p For more details, please visit these pages: 〈a href=http://adapt2.sis.pitt.edu/wiki/CUMULATE Cumulate〉 and 〈a href=http://adapt2.sis.pitt.edu/wiki/CUMULATE_protocol#Protocol_for_reporting_user_activity Cumulate Protocol〉
Related publications:〉
〈ol 〈li Zadorozhny, V., Yudelson, M., and Brusilovsky, P. (2008) A Framework for Performance Evaluation of User Modeling Servers for Web Applications. Web Intelligence and Agent Systems 6(2), 175-191. 〈a href=http://dx.doi.org/10.3233/WIA-2008-0136 DOI〉〉
〈li Yudelson, M., Brusilovsky, P., and Zadorozhny, V. (2007) A user modeling server for contemporary adaptive hypermedia: An evaluation of the push approach to evidence propagation. In Conati, C., McCoy, K. F., and Paliouras, G. Eds., User Modeling, volume 4511 of Lecture Notes in Computer Science, pp 27-36. Springer, 2007. 〈a href=http://www.pitt.edu/~mvy3/assets/YudelsonUM2007.pdf PDF〉 〈a href=http://dx.doi.org/10.1007/978-3-540-73078-1_6 DOI〉〉
〈li Brusilovsky, P., Sosnovsky, S. A., and Shcherbinina, O. (2005). User Modeling in a Distributed E-Learning Architecture. Paper presented at the 10th International Conference on User Modeling (UM 2005), Edinburgh, Scotland, UK, July 24-29, 2005. 〈a href=http://www2.sis.pitt.edu/%7Epeterb/papers/cumulateUM05.pdf PDF〉 〈a href=http://dx.doi.org/10.1007/11527886_50 DOI〉〉
〉
      〈h2 OpenDSA Implementation:〉
〈p OpenDSA is an interactive eTextbook platform that provides comprehensive support for a range of Computer Science-related topics such as Data Structures and Algorithms, Formal Languages, Programming Languages, and more. OpenDSA is LTI powered and also supports a seamless communication of scores, progress tracking, and student data between the tool and the LMS.
OpenDSA offers a collection of exercise types, with the most commonly used being Khan Academy-style exercises and JSAV exercises. The light weight protocol has been integrated to collect scores, state and interactions from both exercise types currently and can be sent back to maybe a server or a  parent page.〉
〈p These are some potential use cases for the light weight protocol for OpenDSA
〉〈ol 〈li 〈b External Tool Integration:〉 OpenDSA can act as an external tool, the exercises can be embedded within other systems via an iframe. In this scenario, the scores and student progress data collected from OpenDSA exercises can be transmitted back to the parent HTML or any server.〉
〈li 〈b Server Interaction and Grade Passback:〉 The lightweight protocol can also facilitate server-side communication. In this use case, student scores are sent directly to OpenDSA server and then to the LTI service for grade passback in the LMS.〉〉
      
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
