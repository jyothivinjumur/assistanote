// Data gathered from http://populationpyramid.net/germany/2015/
$(function () {
    $(document).ready(function () {
        $('#degreesIndicator').highcharts({
            chart: {
                type: 'bar'
            },
            credits:{
                enabled:false
            },
            title: {
                text: 'Degree Distribution'
            },
            subtitle: {
                text: ''
            },
            xAxis:{
                labels:
                {
                  enabled: false
                },
                reversed: false
            },
            yAxis: {
                title: {
                    text: null
                },
                labels: {
                    formatter: function () {
                        return Math.abs(this.value) ;
                    }
                }
            },

            plotOptions: {
                series: {
                    stacking: 'normal'
                }
            },

            tooltip: {
                formatter: function () {
                    return '<b>' + this.series.name + '</b><br/>' +
                        'Person Name: ' + Highcharts.numberFormat(Math.abs(this.point.y), 0);
                }
            },

            series: [{
                name: 'In-Degree',
                color: '#000000',
                data: [-2.0, -2.0, -12, -18, -3, -13, -11]
            }, {
                name: 'Out-Degree',
                color: '#C9C9C9',
                data: [21, 20, 22, 24, 12, 30, 3]
            }]
        });
    });

});