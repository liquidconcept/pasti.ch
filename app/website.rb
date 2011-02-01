# encoding: utf-8
require 'sinatra/base'
#require 'pony'

require File.expand_path('../../config/application', __FILE__)

#
# APPLICATION
#
module Application
  class Website < Sinatra::Base
    set :static, true
    set :public, File.expand_path('../../public', __FILE__)

    # Contact form
    #
    # post '/contact' do
    #   Pony.mail(
    #     :from     => params[:email],
    #     :to       => CONTACT_EMAIL_TO,
    #     :charset  => 'utf-8',
    #     :subject  => CONTACT_SUBJECT_PREFIX + params[:subject],
    #     :body     => params[:message]
    #   )
    #
    #   redirect '/contact_thanks.html'
    # end

  end
end
