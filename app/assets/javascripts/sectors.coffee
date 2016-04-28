# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

chart = undefined
$ ->
  options = ({
    chart: {
      backgroundColor: 'transparent'
      type: 'pie'
    }
    title: {
      text: null
    }
    colors: [@blue, @green, @yellow, @red, @blue_green]
    series: [{}]
  })

  url = '/companies/companies_by_sector'
  $.getJSON url, (data) ->
    options.series[0].data = data
    chart = $('#sector_chart').highcharts(options)
    return
