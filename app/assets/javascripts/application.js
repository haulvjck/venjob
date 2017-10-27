// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require_tree .


$(document).ready(function(){
    // $("input[name='my_job']").change(function(){
    //     $('button#apply_my_form_btn').prop('disabled', false);
    // })
});

function add_favorite(jobId){
  // console.log(id);
}

function redirectPost(url, method) {
    var $form=$(document.createElement('form')).css({display:'none'}).attr("method",method).attr("action",url);
    // var $input=$(document.createElement('input')).attr('name', params['key']).val(params['value']);
    // $form.append($input);
    $("body").append($form);
    $form.submit();
}

function applying_job(path) {
    var jobId = $("input[name='my_job']:checked").val();

    if(jobId){
        redirectPost(path + '?job_id=' + jobId, 'POST');
    } else {
        alert("Please chose a specific job to apply");
    }
}

function get_selected_job() {
    var jobId = $("input[name='my_job']:checked").val();

    if(jobId){
        return jobId
    } else {
        alert("Please chose a specific job to apply");
    }
}

function removeFavorite(node, userId, jobId)
{
    // TODO: call ajax to remove favorite job
    node.parentNode.removeChild(node);
    return false;
}

function markFavorite(userId, jobId){
    // TODO: mark favorite
    console.log(jobId);
}