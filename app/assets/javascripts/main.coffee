$ ->

  $.ajax
    type: 'GET'
    url: 'api/analyzer/index'
    dataType: "json"
    beforeSend: (request) ->
      request.setRequestHeader("Authorization", "Bearer " + $.cookie("jwt"))
    error: (error) ->
      if  error.status == 401
        $('#Signup').show()
    success: ->
      $('#InputArray').show()

  do_auth = (login, password) ->
    $.ajax
      type: 'POST'
      url: 'api/user_token'
      dataType: "json"
      data: {"auth": {"login": login, "password": password}}
      success: (data) ->
        $.cookie("jwt", data['jwt']);
        $('#Signup, #Signin').hide()
        $('#InputArray').show()
      error: ->
        $('#Signin > .alert').addClass('alert-danger')
        $('#Signin > .alert').append('Error. Check your credentials')


  $('#Signup').submit (e) ->
    e.preventDefault()
    form = $(this).serialize()
    login = $("#Signup [name = login]").val()
    password = $("#Signup [name = password]").val()
    $.ajax
      type: 'POST'
      url: 'api/users#create'
      data: form
      complete: (response) ->
        $('#Signup > .alert').empty()
        if  response.status == 201
          do_auth(login, password)
          $('#Signup > .alert').removeClass('alert-danger')
          $('#Signup > .alert').addClass('alert-success')
          $('#Signup > .alert').append('You are successful sign up')
        else
          $('#Signup > .alert').addClass('alert-danger')
          $.each(response.responseJSON, (key, data) ->
            $('#Signup > .alert').append('<br><strong>' + key + '<strong><br> ')
            $.each(data, (index, data) ->
              $('#Signup > .alert').append(data + ', ')
            )
          )


  $('#Signin').submit (e) ->
    e.preventDefault()
    form = JSON.stringify( $(this).serializeArray()[0] )
    login = $("#Signin [name = login]").val()
    password = $("#Signin [name = password]").val()
    do_auth(login, password)

  $('#btn_sign_in').click ->
    $('#Signup').hide()
    $('#Signin').show()
  $('#btn_sign_up').click ->
    $('#Signin').hide()
    $('#Signup').show()
