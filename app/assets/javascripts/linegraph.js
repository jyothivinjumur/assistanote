$(function () {

    Highcharts.setOptions({
        colors: ['#404040']
    });

    $('#graphContainer').highcharts({
        chart: {
            zoomType: 'x'
        },
        credits:{
            enabled:false
        },
        title: {
            text: ''
        },
        subtitle: {
            text: document.ontouchstart === undefined ?
                'Click and Drag to Zoom in' : 'Pinch the chart to zoom in'
        },
        xAxis: {
            type: 'datetime',
            dateTimeLabelFormats: {
                year: '%Y'
            },
            title: {
                text: 'Date'
            },
            tickInterval: 86400000
        },
        yAxis: {
            gridLineWidth: 0,
            title: {
                text: 'Privilege Propensity'
            }
        },
        legend: {
            enabled: false
        },
        plotOptions: {
            area: {
                fillColor: {
                    linearGradient: {
                        x1: 0,
                        y1: 0,
                        x2: 0,
                        y2: 1
                    },
                    stops: [
                        [0, Highcharts.getOptions().colors[0]],
                        [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
                    ]
                },
                marker: {
                    radius: 2
                },
                lineWidth: 1,
                states: {
                    hover: {
                        lineWidth: 1
                    }
                },
                threshold: null
            }
        },

        series: [{
            type: 'area',
            name: '',
            data: $('#graphContainer').data('series'),
            tooltip: {
                valueDecimals: 2
            }
        },
        {
            type: 'flags',
            data: [{
                x: $('#graphContainer').data('dt'),
                text: 'Date on which displayed email was sent',
                title: 'DISPLAYED EMAIL DATE'

            }],
            width: 150,
            showInLegend: true
        }
        ]
    });
});