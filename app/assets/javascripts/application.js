// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap

//= require_tree .
//= require jquery-ui
//= require jquery.turbolinks


$(document).ready(function() {
    $('.mytooltip').tooltipster({
        contentAsHTML: true,
        theme: 'tooltipster-noir',
        trigger: 'hover',
        offsetX: 0,
        offsetY: 0,
        onlyOne: true
    });
});

//----------------- sticky
$(document).ready(function(){
    $("#sticker").sticky({topSpacing:0});
});

