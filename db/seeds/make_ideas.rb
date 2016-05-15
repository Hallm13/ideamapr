sentences = ['The waves were crashing on the shore; it was a lovely sight.',
'Rock music approaches at high velocity.',
'He didn’t want to go to the dentist, yet he went anyway.',
"I'd rather be a bird than a fish.",
"Should we start class now, or should we wait for everyone to get here?",
"She wrote him a long letter, but he didn't read it.",
"-Four comes asking for bread.",            
" you like tuna and tomato sauce- try combining the two. It’s really not as bad as it sounds.",
"She only paints with bold colors; she does not like pastels.",
"He said he was not there yesterday; however, many people saw him there."]
sentences.each do |s|
  unless Idea.where(title: s).count > 1
    Idea.create title: s
  end
end

