extends Control

# this is an example to automatically pick a maximum font size that allows
# fitting all the text in some buttons. Assumes the fonts are using the default
# font.

var buttons:Array # holds all elements we want to manipulate the font size off
var font_size:int


func _ready():
	# get all the buttons
	buttons = get_all_children(self).filter(func(btn):return btn.is_class('Button'))
	
	# only last button triggering the signal ensures all other buttons
	# are already resized. _on_button_resized will handle resizing the font
	buttons[buttons.size()-1].resized.connect(_on_button_resized)


func _on_button_resized():
	var font:Font = get_theme_default_font()
	var default_size = get_theme_default_font_size()
	font_size = 5000 # arbitrary max font size
	for b in buttons:
		var string_size = font.get_string_size(b.text,HORIZONTAL_ALIGNMENT_RIGHT,-1,default_size)
		var button_size = b.get_size()
		var ratios = button_size/string_size
		print(ratios)
		var min_ratio = min(ratios.x,ratios.y)
		font_size = min(font_size, default_size*min_ratio*0.8)
		print(font_size)
		
	for b in buttons:
		b.add_theme_font_size_override("font_size",font_size)



# return all children of a node recursively
func get_all_children(node)->Array:
	var out:Array
	for N in node.get_children():
		out.append(N)
		if N.get_child_count()>0:
			out.append_array(get_all_children(N))
	
	return out

