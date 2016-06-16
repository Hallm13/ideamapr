t = Idea.viewbox_list + SurveyQuestion.viewbox_list + Survey.viewbox_list

xmap = t.map do |vb|
  ["help_text_#{vb.box_key}", (vb.help_text || 'No help text available.')]
end.inject({}) do |memo, pair|
  memo[pair[0]] = pair[1]
  memo
end

xmap.each do |k, v|
  c = CmsContent.find_or_create_by key: k
  c.update_attributes cms_text: v
end
