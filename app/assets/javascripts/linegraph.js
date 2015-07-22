$(function () {
    console.log($('#graphContainer').data('series'))
});

//$(function () {
//    //$.getJSON('http://www.highcharts.com/samples/data/jsonp.php?filename=usdeur.json&callback=?', function (data) {
//        //console.log(data)
//
//        // Create the chart
//        $('#graphContainer').highcharts('StockChart', {
//
//
//            rangeSelector : {
//                selected : 0
//            },
//
//            title : {
//                text : 'USD to EUR exchange rate'
//            },
//
//            tooltip: {
//                style: {
//                    width: '200px'
//                },
//                valueDecimals: 4,
//                shared : true
//            },
//
//            yAxis : {
//                title : {
//                    text : 'Exchange rate'
//                }
//            },
//
//            series : [{
//                name : 'USD to EUR',
//                data : $('#graphContainer').data('series'),
//                id : 'dataseries'
//
//                // the event marker flags
//            }]
//        });
//    //});
//});

$(function () {
//    $.getJSON('http://www.highcharts.com/samples/data/jsonp.php?filename=usdeur.json&callback=?', function (data) {

        // Create the chart
        $('#graphContainer').highcharts('StockChart', {

            credits: {
                enabled: false
            },

            rangeSelector : {
                selected : 0
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
                    text : 'Exchange rate'
                }
            },

            xAxis: {
                type: 'datetime'
            },

            series : [{
                name : 'USD to EUR',
                data : $('#graphContainer').data('series'),
                id : 'dataseries'

                // the event marker flags
            }, {
                type : 'flags',
                data : [{
                    x : 1001320611,
                    title : 'Current date',
                    text : 'Date on which displayed email was sent'
                }],
                onSeries : 'dataseries',
                shape : 'squarepin',
                width : 70
            }]
        });
    //});
});
