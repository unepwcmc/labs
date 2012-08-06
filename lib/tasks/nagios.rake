require 'RMagick'
require 'httparty'

class Nagios
  include HTTParty
  
  #debug_output $stderr #debugger to check httparty output
    
  CONFIG = YAML::load( File.open( Rails.root.join('config/config.yml') ) )['config']
  basic_auth CONFIG["nag_un"], CONFIG["nag_pw"]
  
  
  headers "Content-Type" => "application/json"
end


desc "task to create image of nagios"
task :update_nagios do
  
  x = 20
  y = 20

  #set-up nagios feed
  responser = Nagios.get('http://ec2-50-17-42-47.compute-1.amazonaws.com/nagios/cgi-bin/status-json.cgi')
  ar = []

  responser["services"].each do |service|
    ar << service["service_status"]
  end


  #puts ar.to_json

  size = 40
  square = [0,0,size,0,size,size,0,size,0,0]
  xoff=5
  yoff=5
  columns = 10
  offset = size + 5

  canvas = Magick::Image.new((size + xoff) * columns + 5, 400) {self.background_color = '#232526'}
  gc = Magick::Draw.new
  gc.fill('#AE432E')

  ar.each do |a|  

      #Magick::HatchFill.new('white','lightcyan2')
      gc.polygon(square[0]+xoff,square[1]+yoff,
      square[2]+xoff,square[3]+yoff,square[4]+xoff,
      square[5]+yoff,square[6]+xoff,square[7]+yoff,
      square[8]+xoff,square[9]+yoff)

      if a == "WARNING" 
        gc.fill('#B5712E')
      elsif a == "CRITICAL"
        gc.fill('#AE432E')  
      else
        gc.fill('#7FA416')
      end


      gc.draw(canvas)


      if xoff-5 == columns*offset
        xoff = 5
        yoff+=offset
      else      
        xoff+=offset
      end

  end
  canvas.format = 'png'
  
  puts Rails.root.join('nagios.png').to_s
  
  canvas.write(Rails.root.join('public', 'nagios.png'))
  #canvas.to_blob


    
end


