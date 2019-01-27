getLogin = () ->
  $.ajax
    type: 'GET'
    url: 'api/users/show'
    dataType: "json"
    headers: {"Authorization": "Bearer " + $.cookie("jwt")}
    success: (data) ->
      $('#login_panel > span:last').append(data.login)

signIn = (login, password) ->
  $.ajax
    type: 'POST'
    url: 'api/user_token'
    dataType: "json"
    data: {"auth": {"login": login, "password": password}}
    success: (data) ->
      $.cookie("jwt", data['jwt']);
      checkAuthToken()
    error: ->
      $('#Signin > .alert').addClass('alert-danger')
      $('#Signin > .alert').empty()
      $('#Signin > .alert').append('Error. Check your credentials')

checkAuthToken = () ->
  $.ajax
    type: 'GET'
    url: 'api/analyzer/index'
    dataType: "json"
    headers: {"Authorization": "Bearer " + $.cookie("jwt")}
    error: (error) ->
      if  error.status == 401
        $('#Signup').show()
    success: ->
      $('#Signup, #Signin').hide()
      $('#InputArray').show()
      $('#login_panel').show()
      getLogin()


$ ->

  $('#Signin input[type="submit"]').click (e) ->
    e.preventDefault()
    login = $("#Signin [name = login]").val()
    password = $("#Signin [name = password]").val()
    signIn(login, password)

  $('#Signup input[type="submit"]').click (e) ->
    e.preventDefault()
    formData = $('#Signup').serialize()
    login = $("#Signup [name = login]").val()
    password = $("#Signup [name = password]").val()
    $.ajax
      type: 'POST'
      url: 'api/users#create'
      data: formData
      success: (response)->
        $('#Signup > .alert').empty()
                             .removeClass('alert-danger')
                             .addClass('alert-success')
                             .append('You are successful sign up')
        signIn(login, password)
      error: (response) ->
        alertWrapper = $('#Signup > .alert')
        alertWrapper.empty().addClass('alert-danger')
        $.each(response.responseJSON, (key, data) ->
          alertWrapper.append('<br><strong>' + key + '<strong><br> ')
          $.each(data, (index, data) ->
            alertWrapper.append(data + ', ')
          )
        )

  $('#btn_sign_in').click ->
    $('#Signup').hide()
    $('#Signin').show()
  $('#btn_sign_up').click ->
    $('#Signin').hide()
    $('#Signup').show()

  $('#InputArray input[type="submit"]').click (e) ->
    e.preventDefault()
    data = $('#InputArray').serialize()
    $.ajax
      type: 'POST'
      url: 'api/analyze'
      data: data
      dataType: "json"
      headers: {"Authorization": "Bearer " + $.cookie("jwt")}
      success: (data) ->
        $('#Results').show()
        $('#Results .card-text').empty()
        $('#InputArray > .alert').empty()
        $('#InputArray > .alert').hide()
        $.each(data, (key, data) ->
          $('#Results .card-text').append('<br><strong>' + key + ':<strong><br> ')
          $.each(data, (index, data) ->
            $('#Results .card-text').append(' <i>' + index + '</i>: ' + data + '<br>')
          )
        )
      error: ->
        $('#InputArray > .alert').addClass('alert-danger')
        $('#InputArray > .alert').empty()
        $('#InputArray > .alert').append('Error. Check data. Numbers must be comasepareted.')

  $('#logout').click (e) ->
    $('#js-login').empty()
    $.cookie("jwt", '')
    $('#InputArray').hide()
    $('#login_panel').hide()
    $('#Results').hide()
    $('.alert').hide()
    checkAuthToken()

  checkAuthToken()


