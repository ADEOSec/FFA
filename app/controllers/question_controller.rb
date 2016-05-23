class QuestionController < ApplicationController
  include ActionView::Helpers::NumberHelper
  using TurkishSupport

  before_action :authenticate_user!
  load_and_authorize_resource

  layout 'page'

  def index
    @categories = Category.where(group_id: current_user.group_id)
    user = User.find(current_user.id)
    answer_strings = user.answer_strings.where(is_correct: true).pluck(:question_id)
    answer_texts = user.answer_texts.pluck(:question_id)
    @correct_answers = answer_strings + answer_texts
    wrong_answers = user.answer_strings.where(is_correct: false)
    wrong_answer_group = wrong_answers.group_by{ |answer| answer.question_id }
    @disabled = wrong_answer_group.map{  |answer| answer[0] if answer[1].length == answer[1].last.question.incorrect_limit }
    @disabled = @disabled.compact

    Log.create!(activity: 'Sorular sayfası görüntülendi', user_id: current_user.id,
                user_agent: request.user_agent, ip: request.remote_ip)
  end

  def show
    question = Question.find(params[:id])
    files = question.question_files
    limit = -1
    if question.question_type == 1
      correct_status = question.answer_strings.where(user_id: current_user.id, is_correct: true).length > 0 ? true : false
      incorrect_count = question.answer_strings.where(user_id: current_user.id, is_correct: false).length
      incorrect_status = incorrect_count >= question.incorrect_limit ? true : false if question.incorrect_limit > 0
      limit = question.incorrect_limit - incorrect_count if question.incorrect_limit > 0
      score = question.score
    elsif question.question_type == 2
      correct_status = question.answer_texts.find_by(user_id: current_user.id)

      if correct_status
        score = "#{question.answer_texts.find_by(user_id: current_user.id).score}/#{question.score}"
      else
        score = question.score
      end
    end

    result = {
        title: question.title, content: question.content, score: score,
        question_type: question.question_type, send_url: answer_path(question),
        is_correct: correct_status, disabled: incorrect_status
    }

    result.merge!({limit: limit}) if limit != -1

    json_file = {}

    files.each_with_index do |file, index|
      file_size = number_to_human_size(file.file_file_size)
      json_file[index] = {name: file.file_file_name, size: file_size, url: file.file.url}
    end

    result['files'] = json_file

    Log.create!(activity: "#{params[:id]} idli soru görüntülendi", user_id: current_user.id,
                user_agent: request.user_agent, ip: request.remote_ip)

    render json: result
  end

  def answer
    question = Question.find(params[:id])
    status = 'error'
    message = 'Hata!'
    icon = 'Böyle bir soru bulunamadı.'
    type = 'fa fa-bell'
    disabled = false
    limit = -1

    if question.question_type == 1
      is_correct = question.answer_strings.where(user_id: current_user.id, is_correct: true).length > 0
      incorrect_count = question.answer_strings.where(user_id: current_user.id, is_correct: false).length if question.incorrect_limit > 0
      limit = question.incorrect_limit - incorrect_count if question.incorrect_limit > 0

      if is_correct
        type = 'error'
        status = 'Hata!'
        message = 'Bu soruyu zaten cevapladınız.'
        icon = 'fa fa-bell'
      elsif incorrect_count == question.incorrect_limit
        type = 'error'
        status = 'Hata!'
        message = 'Bu soru için verilen cevap hakkı limitinizi doldurdunuz!'
        icon = 'fa fa-bell'
        disabled = true
      else
        keys = question.question_keys.pluck(:value)
        answer_status = false
        limit -= 1

        keys.map { |key| answer_status = true if key == params[:answer].downcase.strip }

        answer_string = AnswerString.new
        answer_string.question_id = question.id
        answer_string.user_id = current_user.id
        answer_string.value = params[:answer]
        answer_string.is_correct = answer_status

        unless answer_string.save
          type = 'error'
          status = 'Hata!'
          message = 'Bilinmeyen bir hata oluştu lütfen hatayı iws@adeo.com.tr mail adresine bildiriniz.'
          icon = 'fa fa-bell'
        end


        if answer_status
          type = 'success'
          status = 'Başarılı!'
          message = 'Tebrikler! Doğru cevap, diğer sorulara geçebilirsin :)'
          icon = 'fa fa-check'
        else
          type = 'error'
          status = 'Hata!'
          message = "Vermiş olduğunuz cevap yanlış. Daha dikkatli ol :)"
          if question.incorrect_limit > 0
            message = "Vermiş olduğunuz cevap yanlış. #{limit} kere daha deneme hakkın kaldı dikkatli ol :)"
            if limit == 0
              disabled = true
            end
          end
          icon = 'fa fa-bell'
        end
      end

    elsif question.question_type == 2
      is_answered = question.answer_texts.where(user_id: current_user.id).length > 0

      if is_answered
        type = 'error'
        status = 'Hata!'
        message = 'Bu soruyu zaten cevapladınız.'
        icon = 'fa fa-bell'
      else
        answer_text = AnswerText.new
        answer_text.question_id = question.id
        answer_text.user_id = current_user.id
        answer_text.value = params[:answer]
        answer_text.is_correct = false

        if answer_text.save
          type = 'success'
          status = 'Başarılı!'
          message = "Tebrikler! Cevabınız başarı ile gönderildi. Cevabınız değerlendirilip uygun görülen puan verilecektir. (En fazla #{question.score} puan)"
          icon = 'fa fa-check'
        else
          type = 'error'
          status = 'Hata!'
          message = 'Bilinmeyen bir hata oluştu lütfen hatayı iws@adeo.com.tr mail adresine bildiriniz.'
          icon = 'fa fa-bell'
        end
      end

    else
      type = 'error'
      icon = 'fa fa-bell'
      status = 'Hata!'
      message = 'Sorunun tipinde hata oluştu. Lütfen iws@adeo.com.tr\'ye sorun yaşadığınıza dair mail atınız.'
    end

    Log.create!(activity: "#{params[:id]}idli soruya cevap gönderildi", user_id: current_user.id,
                user_agent: request.user_agent, ip: request.remote_ip)

    json = {
        status: status,
        icon: icon,
        type: type,
        message: message,
        disabled: disabled
    }

    json.merge!({limit: limit}) if question.incorrect_limit > 0 and disabled != true
    render json: json
  end
end