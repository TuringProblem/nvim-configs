   import re, json

   with open('/Users/andrewwellington/config/nvim/lua/colors/output.html', 'r') as f:
       html = f.read()

   lines = html.split('\n')

   section_lines_map = {
       'Red': (790, 797),
       'Orange': (797, 804),
       'Yellow': (804, 811),
       'Green': (811, 820),
       'Cyan': (820, 827),
       'Blue': (827, 834),
       'Indigo': (834, 843),
       'Violet_and_purple': (843, 853),
       'Magenta': (853, 860),
       'Pink': (860, 867),
       'Brown': (867, 876),
       'White': (876, 883),
       'Gray': (883, 890),
       'Black': (890, 900),
   }

   def to_lua_key(name):
       name = name.lower()
       name = re.sub(r'[^a-z0-9]+', '_', name)
       name = name.strip('_')
       return name

   def extract_section(start_line, end_line):
       chunk = '\n'.join(lines[start_line-1:end_line-1])
       name_rows = re.findall(r'vertical-align:bottom[^<]*<.*?</tr>', chunk, re.DOTALL)
       color_rows = re.findall(r'<tr><td style="background:#[A-Fa-f0-9]{6}!important.*?</tr>', chunk, re.DOTALL)

       result = {}
       for name_row, color_row in zip(name_rows, color_rows):
           names = re.findall(r'<td[^>]*>.*?>(.*?)</a></td>', name_row)
           names = [re.sub(r'<[^>]+>', '', n).strip() for n in names]
           hexes = re.findall(r'background:(#[A-Fa-f0-9]{6})!important', color_row)

           for name, hex_code in zip(names, hexes):
               lua_key = to_lua_key(name)
               result[lua_key] = hex_code
       return result

   all_sections = {}
   for section, (start, end) in section_lines_map.items():
       all_sections[section] = extract_section(start, end)

   print(json.dumps(all_sections, indent=2))

   #PYEOF

   #Extract full color map with Lua-style keys
