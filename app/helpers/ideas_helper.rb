module IdeasHelper
  def is_image?(type)
    type = type.downcase
    type=~ /image.png/ || type =~ /image.jpeg/ || type =~ /image.gif/ || type =~ /image.jpg/ ||
      type =~ /image.tif/ || type =~ /image.bmp/
  end
end
