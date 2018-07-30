shader_type canvas_item;

uniform sampler2D mask_texture : hint_black;

void fragment(){
    vec4 pixel = texture(TEXTURE,UV);
    vec4 mask = texture(mask_texture,UV);
    
    pixel *= mask;
    COLOR = pixel;
   }