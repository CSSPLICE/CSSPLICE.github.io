$("body").on("jsav-log-event", function(event, eventData) {
  if (eventData.type === 'jsav-exercise-grade-change') {
    SPLICE.reportScoreAndState(eventData.av, eventData.score.correct / eventData.score.total, { currentStep: eventData.currentStep })
  }
  // here you would do something sensible with the eventData
  console.log(eventData);
});
