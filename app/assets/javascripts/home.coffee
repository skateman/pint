# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

app = angular.module 'pintApp', [], ($locationProvider) ->
  $locationProvider.html5Mode
    enabled: true
    requireBase: false

app.controller 'clientController', ($scope, $http, $location, $interval) ->
  localStorage.answered = JSON.stringify []

  getQuestion = ->
    $http.get("/sessions/#{$location.search()['id']}").success((response) ->
      $scope.session = response
      $scope.online = true
    ).error ->
      $scope.online = false
  $scope.poller = $interval(getQuestion, 500)

  $scope.answer = (id) ->
    $http.post("sessions/#{$scope.session.id}/answer", {number: id}).success (response) ->
      $scope.last_slide = $scope.session.slide
      $scope.id = id
      setAnswered($scope.session.question.id)
      $scope.session = response

  $scope.checked = (id) ->
    ($scope.last_slide == $scope.session.slide) && (id == $scope.id)

  $scope.unchecked = (id) ->
    ($scope.last_slide == $scope.session.slide) && (id != $scope.id)

  setAnswered = (id) ->
    answered = JSON.parse localStorage.answered
    answered.push id
    localStorage.setItem "answered", JSON.stringify answered

  $scope.getAnswered = (id) ->
    answered = JSON.parse localStorage.answered
    answered.indexOf(id) != -1


app.controller 'presentationsController', ($scope, $http, $location, $interval) ->
  # List presentations
  $http.get('/presentations').success (response) ->
    $scope.presentations = response

  # Start a presentation
  $scope.start = (id) ->
    $http.post('/sessions', {presentation_id: $scope.presentations[id].id, slide: 0}).success (response) ->
      $scope.session = response
      $scope.presentation = $scope.presentations[id]
      $scope.poller = $interval(getQuestion, 500)
      qr.canvas
        canvas: document.getElementById('qr-code')
        value: "#{$location.protocol()}://#{$location.host()}:#{$location.port()}/client?id=#{$scope.session.id}"
        level: 'H'
        size: 10
      $scope.show_pres = true

  # Exit from the presentation
  $scope.exit = ->
    $interval.cancel($scope.poller)
    $http.delete("/sessions/#{$scope.session.id}").success (response) ->
      $scope.show_pres = false

  # Ask for the next slide
  $scope.nextSlide = ->
    if $scope.session.slide < $scope.presentation.slides
      $http.patch("/sessions/#{$scope.session.id}", {slide: $scope.session.slide+1}).success (response) ->
        $scope.session = response

  # Ask for the previous slide
  $scope.prevSlide = ->
    if $scope.session.slide > 0
      $http.patch("/sessions/#{$scope.session.id}", {slide: $scope.session.slide-1}).success (response) ->
        $scope.session = response

  $scope.getPercent = (k) ->
    parseInt($scope.session.results[k]) / parseInt($scope.session.answers).toFixed(2) * 100

  # Update the session context
  getQuestion = ->
    $http.get("/sessions/#{$scope.session.id}").success (response) ->
      $scope.session = response

  # Trigger creation form
  $scope.new = ->
    $scope.show_new = true

  # Edit a presentation
  $scope.edit = (id) ->
    $scope.presentation = $scope.presentations[id]
    $scope.toDeleteQuestions = []
    $http.get("/presentations/#{$scope.presentation.id}/questions").success (response) ->
      $scope.questions = response
      $scope.show_edit = true

  # Update an existing presentation
  $scope.update = (b) ->
    $scope.verifySlides()
    if b.$valid
      angular.forEach $scope.toDeleteQuestions, (q) ->
        $http.delete("/presentations/#{$scope.presentation.id}/questions/#{q}")
      angular.forEach $scope.questions, (q) ->
        if q.id
          $http.patch("/presentations/#{$scope.presentation.id}/questions/#{q.id}", q)
        else
          $http.post("/presentations/#{$scope.presentation.id}/questions", q)
      $http.patch("/presentations/#{$scope.presentation.id}", $scope.presentation).success (response) ->
        $scope.presentation = response
        $scope.show_edit = false

  # Delete a presentation
  $scope.destroy = (id) ->
    $http.delete("/presentations/#{$scope.presentations[id].id}").success ->
      $scope.presentations.splice(id, 1)

  # Loop for n times helper
  $scope.loop = (n) ->
    new Array(n)

  # Append a new question
  $scope.newQuestion = ->
    $scope.questions.push({slide: 1, choices: ['', '']})
    $scope.verifySlides()

  # Remove a question
  $scope.destroyQuestion = (id) ->
    $scope.toDeleteQuestions.push($scope.questions[id].id) if $scope.questions[id].id
    $scope.questions.splice(id, 1)

  # Append a choice
  $scope.newChoice = (q_id) ->
    $scope.questions[q_id].choices.push('')

  # Remove a choice
  $scope.destroyChoice = (id, q_id) ->
    $scope.questions[q_id].choices.splice(id, 1)

  # Slide duplication validation
  $scope.verifySlides = ->
    scoreboard = {}
    angular.forEach $scope.questions, (v) ->
      if scoreboard[v.slide]
        scoreboard[v.slide].form['question[slide]'].$setValidity 'duplicate', false
        v.form['question[slide]'].$setValidity 'duplicate', false
      else
        scoreboard[v.slide] = v
        v.form['question[slide]'].$setValidity 'duplicate', true
