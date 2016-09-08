module SurveyReportsHelper
  def width_ratio(num, den)
    "width: #{num.to_f*100/den}%; float: left; display: block; "
  end
  
  def width12(num)
    "width: #{num.to_f/12*100}%; float: left; display: block; "
  end
  def tr100
    width12(12)
  end
  def tr50
    width12(6)
  end
  def boldfont
    "font-weight: bold; "
  end
  def h1font
    "font-size: 1.75em; "
  end
  def reportpara
    "margin-bottom: 20px; "
  end
  def h2font
    "font-size: 1.175em; "
  end
  def centeralign
    "text-align: center; "
  end
  def themegreen
    "color: #409599; "
  end
  def themered
    "color: #C54943; "
  end
  def theme_formborder_gray
    "#F0F1F2"
  end
  def forcetopmargin(height)
    "display: block; margin-top: #{height}px; "
  end
  def forcetoppadding(height, border: true)
    "display: block; padding-top: #{height}px; " + (border ? "border-top: solid 2px #{theme_formborder_gray}; " : '')
  end

  def mobile_breakpoint
    '450px'
  end
end
