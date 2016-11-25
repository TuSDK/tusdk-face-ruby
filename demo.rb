# -*- coding: utf-8 -*-
$LOAD_PATH << '.'

require 'tuapi'

begin
	# 公有key
	pid = ''
	# 私有key
	key = ''	

	face = TuApi::Face.new(pid, key)
	detectionData = face.request('detection', {:file => "path_to_file"})
	p detectionData

rescue
	puts $@
	puts $!
end