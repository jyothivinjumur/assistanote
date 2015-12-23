$(function () {

    $('#correlationMat').highcharts({

        chart: {
            type: 'heatmap',
            marginTop: 40,
            marginBottom: 80,
            plotBorderWidth: 2
        },
        credits:{
            enabled:false
        },
        title: {
            text: 'Response Time (Above the Diagonal), Dispersion (Below the Diagonal)'
        },

        xAxis: {
            categories: ['Alexander', 'Marie', 'Maximilian', 'Sophia', 'Lukas']
        },

        yAxis: {
            categories: ['Alexander', 'Marie', 'Maximilian', 'Sophia', 'Lukas'],
            title: null
        },

        colorAxis: {
            min: 0,
            minColor: '#FFFFFF',
            maxColor: Highcharts.getOptions().colors[1]
        },

        legend: {
            enabled: false
        },

        tooltip: {
            formatter: function () {
                return '<b>' + this.series.xAxis.categories[this.point.x] + '</b> sold <br><b>' +
                    this.point.value + '</b> items on <br><b>' + this.series.yAxis.categories[this.point.y] + '</b>';
            }
        },

        series: [{
            name: '',
            borderWidth: 1,
            data: [[0, 0, 10], [0, 1, 19], [0, 2, 8], [0, 3, 24], [0, 4, 0], [1, 0, 92], [1, 1, 58], 
            [1, 2, 78], [1, 3, 0], [1, 4, 48], [2, 0, 35], [2, 1, 15], [2, 2, 0], [2, 3, 64], [2, 4, 52], 
            [3, 0, 72], [3, 1, 0], [3, 2, 114], [3, 3, 19], [3, 4, 16], [4, 0, 0], [4, 1, 5], [4, 2, 8], 
            [4, 3, 117], [4, 4, 115]],
            dataLabels: {
                enabled: true,
                color: '#000000'
            }
        }]

    });
});