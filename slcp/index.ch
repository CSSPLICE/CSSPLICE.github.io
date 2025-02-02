〈html  
  〈head  
    〈title SPLICE Working Group: Smart Learning Content Protocols〉 
    〈meta http-equiv=content-type content='text/html; charset=UTF-8'〉
    〈link rel=stylesheet href=../cssplice.css type=text/css〉 
  〉 
  〈body  
    〈div#content  
      〈h1 SPLICE Working Group: Smart Learning Content Protocols〉 
      〈p 〈b Leaders〉: Cay Horstmann, Cliff Shaffer〉 
      〈p 〈b Active Participants〉: Adeyemi Aina, Kamil Akhuseyinoglu, Peter Brusilovsky, Alex Hicks, Brad Miller〉 
      〈p 〈b Purpose〉 Standard learning system APIs such as LTI are complex and often incorporate server-side components. Too often systems that integrate smart learning content use proprietary APIs that restrict interoperability. Our goal is to enable learning systems to make use of compliant smart content by lowering the cost of entry through simple APIs. The purpose of this working group is to formulate and test APIs that allow smart learning content authors to signal user activity, and learning system implementers to record scores, and optionally store logging information and student work.〉
      〈p 〈b The iframe protocol〉 Commonly, learning systtems embed smart learning content in iframes, in order to isolate the JavaScript for the learning content from the JavaScript for the learning system. We have specified a 〈a href=iframe-protocol.html standard postMessage protocol〉 for communicating between the learning content and the learning system. See the following documents for details.〉
      〈ul
        〈li 〈a href=iframe-protocol-rationale.html Rationale〉〉
        〈li 〈a href=iframe-protocol-specification.html Specification〉〉
        〈li 〈a href=iframe-protocol-prior-art.html Prior art〉〉
        〈li 〈a href=iframe-protocol-demos.html Demos〉〉
      〉
      〈p We encourage all implementors of smart learning content and of learning systems to implement this protocol. Please contact us with any questions and suggestions.〉
      〈p 〈b Future directions〉 While iframes provide isolation, they are not optimal for pages that embed many content elements. We would like to explore a standard approach of assembling smart content from disparate sources without the use of iframes.〉
      〈p We are also interested in standardizing communication that goes beyond scores and state, such as learner models.〉
      〈p 〈b Get in Contact: 〉 〈a href=https://groups.google.com/g/splice-smart-learning-content-protocol Google Group〉〉 
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
