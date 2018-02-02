# frozen_string_literal: true

ActiveAdmin.register OutgoingWebhook do
  menu parent: 'Webhooks'

  permit_params :name, :url, :processor_id, :system

  form do |f|
    f.inputs do
      f.input :name
      f.input :url
      f.input :system
      f.input :processor, label: 'Processor', as: :select, collection: Processor.all, include_blank: true
    end
    f.actions
  end
end
