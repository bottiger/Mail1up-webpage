class MailsController < ApplicationController
before_filter :get_tokens

def index
@mail = Mail.new
end

def show
logger.debug "show-method"
if @access_token
response = @access_token.get('https://www.googleapis.com/userinfo/email?alt=json')
logger.debug @access_token.inspect
        logger.debug response.inspect
if response.is_a?(Net::HTTPSuccess)
        @email = JSON.parse(response.body)['data']['email']
        else
#STDERR.puts "could not get email: #{response.inspect}"
        render :text => "could not get email: #{response.inspect}"
        end
        else
        render :text => "hep" #link_to "Sign in", 1, :method => :put
        end
        end

        def new
        end

        def create
        @request_token = @consumer.get_request_token(:oauth_callback => "#{request.scheme}://#{request.host}:#{request.port}/auth")
        session[:oauth][:request_token] = @request_token.token
        session[:oauth][:request_token_secret] = @request_token.secret
        redirect_to @request_token.authorize_url
        end

        def auth 
        @access_token = @request_token.get_access_token :oauth_verifier => params[:oauth_verifier]
        session[:oauth][:access_token] = @access_token.token
        session[:oauth][:access_token_secret] = @access_token.secret
        logger.debug @access_token.inspect

email = get_email(@access_token)
        if email
        @mail = Mail.new
        @mail.mail = email
        @mail.token = @access_token.token
        @mail.secret = @access_token.secret
        @mail.save!
        auth_file = render_to_string :action => 'xoauth', :layout => false
        reset_invocation_response
        @maildir = '/media/s3ql/' + email + '/Mail'
        mbsync_config = render_to_string :action => 'mbconf', :layout => false
        reset_invocation_response

        @consumer_key = Mail.consumer_key
        @consumer_secret = Mail.consumer_secret
        @mail.write_config_files(auth_file, mbsync_config)
        end

        redirect_to :action => 'show', :id => @mail.id
        end

        protected

        def reset_invocation_response
self.instance_variable_set(:@_response_body, nil)
        response.instance_variable_set :@header, Rack::Utils::HeaderHash.new("cookie" => [], 'Content-Type' => 'text/html')
        end

def get_email(access_token)
        response = access_token.get('https://www.googleapis.com/userinfo/email?alt=json')
if response.is_a?(Net::HTTPSuccess)
        return JSON.parse(response.body)['data']['email']
        else
        return nil
        end
        end

        def get_tokens
        logger.debug "Running get_tokens..."
        session[:oauth] ||= {}

#consumer_key = ENV["CONSUMER_KEY"] || ENV["consumer_key"] || "anonymous"
#consumer_secret = ENV["CONSUMER_SECRET"] || ENV["consumer_secret"] || "anonymous"

        consumer_key = "mail1up.com"
        consumer_secret = "2Gsz5p93XwqZWZL3b5wd8aQP"

        @consumer ||= OAuth::Consumer.new(consumer_key, consumer_secret,
                        :site => "https://www.google.com",
                        :request_token_path => '/accounts/OAuthGetRequestToken?scope=https://mail.google.com/%20https://www.googleapis.com/auth/userinfo%23email',
                        :access_token_path => '/accounts/OAuthGetAccessToken',
                        :authorize_path => '/accounts/OAuthAuthorizeToken'
                        )

        if !session[:oauth][:request_token].nil? && !session[:oauth][:request_token_secret].nil?
@request_token = OAuth::RequestToken.new(@consumer, session[:oauth][:request_token], session[:oauth][:request_token_secret])
        end

        if !session[:oauth][:access_token].nil? && !session[:oauth][:access_token_secret].nil?
@access_token = OAuth::AccessToken.new(@consumer, session[:oauth][:access_token], session[:oauth][:access_token_secret])
        end
        end

        end
