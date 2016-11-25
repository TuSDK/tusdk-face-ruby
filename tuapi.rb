# -*- coding: utf-8 -*-

require 'digest'
require 'json'
require 'rest-client'

module TuApi
	
	 API_URL = 'https://srv.tusdk.com/srv/face/'

	class Face

		def initialize(pid, key)
			@pid = pid
			@key = key
		end

		def request(method, image = {}, params = {})
			if image.has_key? :url
				@url = image[:url]
			end
			if image.has_key? :file
				@file = image[:file]
			end

			if @pid == '' || @key == ''
				raise 'empty pid or key'
			end

			_params = {:pid => @pid}
			_params[:t] = Time.now.to_i

			if @url != nil
				_params[:url] = @url
			elsif @file == nil
				raise 'url or file required'
			end

			_params.merge!(params)
			_params[:sign] = TuApi.sign(_params, @key)

			if @file != nil
				_params[:pic] = File.new(@file, 'rb')
			end
			
			return JSON.parse(post(API_URL + method, _params))
		end

		def post(url, params)		
			rsp = RestClient.post url, params
			if rsp.code != 200
				raise "Error : http response code #{rsp.code}"
			end
			return rsp.to_s
		end
	end

	def TuApi.sign(params = {}, key)
		sorted =  params.sort
		signstr = ''
		sorted.each  do |k, v|
			signstr += k.downcase.to_s + v.to_s
		end
		signstr += key
		Digest::MD5.hexdigest(signstr)
	end

end
