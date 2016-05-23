ActiveAdmin.register Question do

  permit_params :category_id, :title, :content, :score, :question_type, :incorrect_limit,
                question_keys_attributes: [:value, :id, :_destroy],
                question_files_attributes: [:file, :id, :_destroy]

  before_create do |question|
    question.admin_user = current_admin_user
  end

  before_update do |question|
    question.admin_user = current_admin_user
  end

  index do
    selectable_column
    id_column
    column :category
    column :title
    column :score
    column :question_type do |question|
      ['Kesin Cevap', 'Yorum'][question.question_type - 1]
    end
    actions
  end

  form do |f|
    f.inputs 'Soru Bilgileri' do
      f.input :category
      f.input :title
      f.input :content
      f.input :score
      f.input :incorrect_limit
      f.input :question_type, as: :select,  collection: [['Kesin Cevap', 1], ['Yorum', 2]],
              include_blank: false
    end

    f.inputs 'Cevaplar' do
      f.has_many :question_keys, allow_destroy: true, new_record: true do |qk|
        qk.input :value
      end
    end

    f.inputs 'Dosyalar' do
      f.has_many :question_files, allow_destroy: true, new_record: true do |qf|
        qf.input :file, as: :file, hint: qf.object.file_file_name
      end
    end

    f.actions
  end

  show do |current_question|
    attributes_table do
      row :category
      row :score
      row :title
      row :content
      row :incorrect_limit
    end

    panel 'Cevaplar' do
      attributes_table_for current_question.question_keys do
        row :value
      end
    end

    panel 'Dosyalar' do
      attributes_table_for current_question.question_files do
        row :file do |file|
          file.file_file_name
        end
      end
    end
  end

  filter :admin_user, :collection => proc { AdminUser.all.pluck(:user_name, :id) }
  filter :title
  filter :question_type
  filter :category

end
