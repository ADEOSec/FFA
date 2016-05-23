class PagesController < ApplicationController
  layout  'page'

  def intro
  end

  def statics
    @categories = {}
    Group.all.pluck(:name).each do |group_name|
      @categories[group_name] = []
    end

    scores = Score.all.order(:created_at)

    if scores.length > 0
      @date_groups  = scores.map{ |score| score.created_at.strftime("%H:00 - #{score.created_at.hour + 1}:00  %d/%b/%Y") }.uniq
      user_scores   = scores.group_by{ |score| score.user.user_name }
      users         = user_scores.keys

      users.each do |user|
        tmp_data = []
        score_groups = user_scores[user].group_by{ |score| score.created_at.strftime("%H:00 - #{score.created_at.hour + 1}:00  %d/%b/%Y") }
        @date_groups.each_with_index do |group, index|
          if score_groups[group]
            tmp_data[index]   = score_groups[group].map{ |score| score.score }.sum
            tmp_data[index]  += tmp_data[index-1] if index != 0
          else
            tmp_data[index]   = 0
            tmp_data[index]  += tmp_data[index-1] if index != 0
          end
        end

        color = "##{SecureRandom.hex(3)}"

        tmp = {
            label: user,
            fill: false,
            lineTension: 0.1,
            backgroundColor: color,
            borderColor: color,
            borderCapStyle: 'butt',
            borderDash: [],
            borderDashOffset: 0.0,
            borderJoinStyle: 'round',
            pointBorderColor: color,
            pointBackgroundColor: color,
            pointBorderWidth: 5,
            pointHoverRadius: 5,
            pointHoverBackgroundColor: color,
            pointHoverBorderColor: color,
            pointHoverBorderWidth: 2,
            pointRadius: 1,
            pointHitRadius: 10,
            data: tmp_data,
            color: SecureRandom.hex(3)
        }

        @categories[User.find_by_user_name(user).group.name] << tmp
      end
    else
      @categories = nil
    end
  end
end