〈html  
  〈head  
    〈title SPLICE Working Group: Smart Learning Content Protocols〉 
    〈meta http-equiv=content-type content='text/html; charset=UTF-8'〉
    〈link rel=stylesheet href=../cssplice.css type=text/css〉 
    〈script type='text/javascript' charset='utf-8' src='splice-parent.js'〉
  〉 
  〈body  
    〈div#content  
      〈h1 SPLICE iframe Protocol: Demos〉
      〈p Look at the console log in the development tools (Ctrl+Shift+J or ⌘+Shift+J).〉
      〈h2 CodeCheck〉
      〈iframe width=100% src=https://codecheck.io/files/wiley/ch-bj4cc-c06_exp_6_105〉
      〈h2 JSAV〉
      〈p Uses this 〈a href=jsav-to-splice.js simple adapter〉〉
      〈iframe width=100% src=https://horstmann.com/private/jsav/AV/Graph/DijkstraPE.html〉
      〈h2 JS-Parsons〉
      〈p The widget setup is modified as follows:〉
      
      〈pre
parson = new ParsonsWidget({
  action_cb: logData => {
    if (logData.type === 'feedback') 
      SPLICE.reportScoreAndState('turtle-test', logData.success ? 1 : 0, logData.output)
  },
  . . .
})
〉
      〈iframe width=100% src=https://horstmann.com/private/js-parsons/examples/turtle-test.html〉
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
