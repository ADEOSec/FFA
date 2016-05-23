// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require pnotify.custom.min
//= require_self

function set_answer(question_type) {
    var answer_html;
    if (question_type == '1') {
        answer_html = '<input type="text" name="answer" required autocomplete="off" ';
        answer_html += 'placeholder="Lütfen cevabınızı yazınız." class="form-control">';
    } else if (question_type == '2') {
        answer_html  = '<div class="alert alert-warning" role="alert"> <strong>Uyarı!</strong> <br>';
        answer_html += 'Yalnızca bir defa cevap gönderebilirsiniz. Gönderirken dikkatli ol :)</div>';
        answer_html += '<textarea name="answer" required placeholder="Lütfen cevabınızı yazınız."';
        answer_html += 'class="form-control" rows="5">';
    } else {
        answer_html = '<div class="alert alert-danger" role="alert"> <strong>Hata!</strong> <br>';
        answer_html += 'Soru tipi belirlenemedi. Lütfen iws@adeo.com.tr\'ye sorun yaşadığınıza ';
        answer_html += 'dair mesaj atınız</div>';
    }

    return answer_html
}

function set_file(files) {
    var i = 0,
        file_html = '',
        length = Object.keys(files).length;

    if (length > 0) file_html = '<h5>Soruya Ait Dosyalar</h5>';

    for (i = 0; i < length; i++) {
        file_html += '<i class="fa fa-file-archive-o"></i> ';
        file_html += ' <a href="' + files[i].url + '" download>' + files[i].name + ' [ ';
        file_html += files[i].size + ' ]</a><br/>';
    }

    return file_html;
}

$(document).ready(function () {
    $('.question').click(function (e) {
        var modal = $('#question-modal'),
            modal_body = $('#question-modal #modal-content p'),
            modal_header = $('#question-modal #modal-title'),
            modal_score = $('#question-modal #modal-score'),
            modal_file = $('#question-modal #modal-file'),
            modal_answer = $('#question-modal #modal-answer'),
            modal_send = $('#question-modal #modal-send'),
            modal_limit = $('.modal-footer span'),
            answer_html, file_html;

        $.post($(this).data('href'), function (result) {
            modal
                .on('show.bs.modal', function () {
                    modal_header.text(result.title);
                    modal_body.html(result.content.replace(/\n/g, "<br />"));
                    modal_score.text(result.score);
                    file_html = set_file(result.files);
                    modal_file.html(file_html);
                    modal_limit.text('');
                    answer_html = set_answer(result.question_type);
                    modal_answer.html(answer_html);
                    modal_send.prop('disabled', false);
                    modal_send.prop('data-href', false);
                    modal_send.attr('data-href', result.send_url);
                    modal_send.removeClass('btn-success');
                    if(result.limit != undefined){
                        modal_limit.removeClass();
                        if(result.limit == 0){
                            modal_limit.addClass('pull-left alert alert-danger');
                        }else{
                            modal_limit.addClass('pull-left alert alert-warning');
                        }
                        modal_limit.text('Bu soru için kalan yanıt hakkınız: ' + result.limit)
                    }else{
                        modal_limit.remove();
                    }
                    if(result.is_correct){
                        modal_send.attr('disabled', '');
                        modal_send.addClass('btn-success');
                        modal_answer.html('<div class="alert alert-success" role="alert">Bu soruya zaten cevap verdiniz. Zaman kaybetmeden diğerlerine bak :)</div>');
                        modal_limit.remove();
                    }
                    if(result.disabled){
                        modal_send.attr('disabled', '');
                        modal_send.addClass('btn-danger');
                        modal_answer.html('<div class="alert alert-danger" role="alert">Bu soru için verilen cevap hakkı limitinizi doldurdunuz!</div>');
                    }
                })
                .modal();
            e.preventDefault();
        });

    });

    $('#modal-send').click(function (e) {
        var href = $('#modal-send').attr('data-href');

        $.ajax({
            url: href,
            type: 'post',
            data: {
                answer: $('[name=answer]').val()
            },
            success: function(data) {
                new PNotify({
                    title:  data.status,
                    text:   data.message,
                    icon:   data.icon,
                    type:   data.type
                });

                if( data.type == 'success' ){
                    var modal_answer = $('#question-modal #modal-answer'),
                        modal_send = $('#question-modal #modal-send'),
                        target_href = $('#question-' + href.split('/')[2]);

                    target_href.removeClass('btn-info');
                    target_href.addClass('btn-success');
                    modal_send.attr('disabled', '');
                    modal_send.addClass('btn-success');
                    modal_limit.remove();
                    modal_answer.html('<div class="alert alert-success" role="alert">' + data.message + '</div>');
                }
                if(data.limit != undefined){
                    var modal_limit = $('.modal-footer span');
                    modal_limit.removeClass();
                    if(data.limit == 0){
                        modal_limit.addClass('pull-left alert alert-danger');
                    }else{
                        modal_limit.addClass('pull-left alert alert-warning');
                    }
                    modal_limit.text('Bu soru için kalan yanıt hakkınız: ' + data.limit)
                }
                if(data.disabled == true){
                    var modal_answer = $('#question-modal #modal-answer'),
                        modal_send = $('#question-modal #modal-send'),
                        modal_limit = $('.modal-footer span'),
                        target_href = $('#question-' + href.split('/')[2]);
                    target_href.removeClass('btn-info');
                    target_href.addClass('btn-danger');
                    modal_send.attr('disabled', '');
                    modal_send.removeClass('btn-info');
                    modal_send.addClass('btn-danger');
                    modal_answer.html('<div class="alert alert-danger" role="alert">' + data.message + '</div>');
                    modal_limit.addClass('alert-danger');
                    modal_limit.text('Bu soru için kalan yanıt hakkınız: 0' );
                }
            },
            error: function() {
                new PNotify({
                    title:'Hata!',
                    text: 'Bir hata oluştu lütfen sayfayı yenileyerek tekrar deneyiniz!',
                    icon: 'fa fa-bell',
                    type: 'error'
                });
            }
        });
    });
});