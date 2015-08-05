$(function () {
        // Create the chart
        $('#graphContainer').highcharts('StockChart', {

            credits: {
                enabled: false
            },



            rangeSelector : {
                selected : 5
            },

            title : {
                text : ''
            },

            tooltip: {
                style: {
                    width: '200px'
                },
                valueDecimals: 4,
                shared : true
            },

            yAxis : {
                title : {
                    text : ''
                }
            },

            xAxis: {
                type: 'datetime'
            },

            series : [{
                name : '',
                data : $('#graphContainer').data('series'),
                id : 'dataseries',
                lineWidth : 0,
                marker : {
                    enabled : true,
                    radius : 2
                },
                tooltip: {
                    valueDecimals: 2
                }

                // the event marker flags
            }, {
                type : 'flags',
                data : [{
                    x : $('#graphContainer').data('dt'),
                    title : 'X',
                    text : 'Date on which displayed email was sent'
                }],
                onSeries : 'dataseries',
                shape : 'circlepin',
                width : 15
            }]
        });
    //});
});
