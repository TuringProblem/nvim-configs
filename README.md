# Welcome to my configs :p

> here is a quick chart on how to navigate using this config file:

<table>
  <thead>
    <tr>
      <th>Mode</th>
      <th>Key</th>
      <th>Command</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <!-- General Keymaps -->
    <tr>
      <td>n</td>
      <td>&lt;leader&gt;nh</td>
      <td>:nohl&lt;CR&gt;</td>
      <td>Clear search highlights</td>
    </tr>
    <tr>
      <td>n</td>
      <td>&lt;leader&gt;+</td>
      <td>&lt;C-a&gt;</td>
      <td>Increment number</td>
    </tr>
    <tr>
      <td>n</td>
      <td>&lt;leader&gt;-</td>
      <td>&lt;C-x&gt;</td>
      <td>Decrement number</td>
    </tr>
    <!-- Window Management -->
    <tr>
      <td>n</td>
      <td>&lt;leader&gt;sv</td>
      <td>&lt;C-w&gt;v</td>
      <td>[S]plit window [V]ertically</td>
    </tr>
    <tr>
      <td>n</td>
      <td>&lt;leader&gt;sh</td>
      <td>&lt;C-w&gt;s</td>
      <td>[S]plit window [H]orizontally</td>
    </tr>
    <tr>
      <td>n</td>
      <td>&lt;leader&gt;se</td>
      <td>&lt;C-w&gt;=</td>
      <td>[S]plits size [E]qually</td>
    </tr>
    <tr>
      <td>n</td>
      <td>&lt;leader&gt;sc</td>
      <td>&lt;cmd&gt;close&lt;CR&gt;</td>
      <td>[S]plit window [C]lose</td>
    </tr>
    <!-- Window Switching -->
    <tr>
      <td>n</td>
      <td>&lt;leader&gt;vn</td>
      <td>&lt;cmd&gt;windo wincmd k&lt;CR&gt;</td>
      <td>[V]iew [N]ext</td>
    </tr>
    <tr>
      <td>n</td>
      <td>&lt;leader&gt;vb</td>
      <td>&lt;cmd&gt;windo wincmd h&lt;CR&gt;</td>
      <td>[V]iew [B]ack</td>
    </tr>
    <!-- Tab Management -->
    <tr>
      <td>n</td>
      <td>&lt;leader&gt;to</td>
      <td>&lt;cmd&gt;tabnew&lt;CR&gt;</td>
      <td>[T]ab [O]pen (new)</td>
    </tr>
    <tr>
      <td>n</td>
      <td>&lt;leader&gt;tc</td>
      <td>&lt;cmd&gt;tabclose&lt;CR&gt;</td>
      <td>[T]ab [C]lose</td>
    </tr>
    <tr>
      <td>n</td>
      <td>&lt;leader&gt;tn</td>
      <td>&lt;cmd&gt;tabn&lt;CR&gt;</td>
      <td>[T]ab [N]ext - (right)</td>
    </tr>
    <tr>
      <td>n</td>
      <td>&lt;leader&gt;tp</td>
      <td>&lt;cmd&gt;tabp&lt;CR&gt;</td>
      <td>[T]left ab [P]revious - (left)</td>
    </tr>
    <tr>
      <td>n</td>
      <td>&lt;leader&gt;tf</td>
      <td>&lt;cmd&gt;tabnew %&lt;CR&gt;</td>
      <td>Open current buffer in new tab</td>
    </tr>
    <!-- Visual Mode Indentation -->
    <tr>
      <td>v</td>
      <td>&lt;</td>
      <td>&lt;gv</td>
      <td>Indent left in visual mode</td>
    </tr>
    <tr>
      <td>v</td>
      <td>&gt;</td>
      <td>&gt;gv</td>
      <td>Indent right in visual mode</td>
    </tr>
    <!-- Telescope / LSP Keymaps -->
    <tr>
      <td>n</td>
      <td>gd</td>
      <td>&lt;cmd&gt;Telescope lsp_definitions&lt;cr&gt;</td>
      <td>Go to definition</td>
    </tr>
    <tr>
      <td>n</td>
      <td>gr</td>
      <td>&lt;cmd&gt;Telescope lsp_references&lt;cr&gt;</td>
      <td>Find references</td>
    </tr>
    <tr>
      <td>n</td>
      <td>gi</td>
      <td>&lt;cmd&gt;Telescope lsp_implementations&lt;cr&gt;</td>
      <td>Find implementations</td>
    </tr>
    <tr>
      <td>n</td>
      <td>gt</td>
      <td>&lt;cmd&gt;Telescope lsp_type_definitions&lt;cr&gt;</td>
      <td>Find type definitions</td>
    </tr>
    <tr>
      <td>n</td>
      <td>&lt;leader&gt;ff</td>
      <td>&lt;cmd&gt;Telescope find_files&lt;cr&gt;</td>
      <td>Fuzzy find files in cwd</td>
    </tr>
    <tr>
      <td>n</td>
      <td>&lt;leader&gt;fr</td>
      <td>&lt;cmd&gt;Telescope oldfiles&lt;cr&gt;</td>
      <td>Fuzzy find recent files</td>
    </tr>
    <tr>
      <td>n</td>
      <td>&lt;leader&gt;fs</td>
      <td>&lt;cmd&gt;Telescope live_grep&lt;cr&gt;</td>
      <td>Find string in cwd</td>
    </tr>
    <tr>
      <td>n</td>
      <td>&lt;leader&gt;fc</td>
      <td>&lt;cmd&gt;Telescope grep_string&lt;cr&gt;</td>
      <td>Find string under cursor in cwd</td>
    </tr>
    <tr>
      <td>n</td>
      <td>&lt;leader&gt;ft</td>
      <td>&lt;cmd&gt;TodoTelescope&lt;cr&gt;</td>
      <td>Find todos</td>
    </tr>
    <!-- Oil.nvim -->
    <tr>
      <td>n</td>
      <td>&lt;space&gt;-</td>
      <td>&lt;CMD&gt;Oil&lt;CR&gt;</td>
      <td>Runs the parent directory</td>
    </tr>
    <!-- Terminal Management -->
    <tr>
      <td>n, t</td>
      <td>&lt;leader&gt;tt</td>
      <td>toggle_terminal()</td>
      <td>[T]oggle [T]erminal</td>
    </tr>
    <tr>
      <td>n, t</td>
      <td>&lt;leader&gt;tf</td>
      <td>toggle_terminal_focus()</td>
      <td>Toggle focus between terminal and editor</td>
    </tr>
    <tr>
      <td>n, t</td>
      <td>&lt;leader&gt;tr</td>
      <td>move_terminal("right")</td>
      <td>Move terminal right</td>
    </tr>
    <tr>
      <td>n, t</td>
      <td>&lt;leader&gt;tl</td>
      <td>move_terminal("left")</td>
      <td>Move terminal left</td>
    </tr>
    <tr>
      <td>n, t</td>
      <td>&lt;leader&gt;tb</td>
      <td>move_terminal("bottom")</td>
      <td>Move terminal bottom</td>
    </tr>
    <tr>
      <td>n, t</td>
      <td>&lt;leader&gt;tc</td>
      <td>move_terminal("center")</td>
      <td>Center terminal</td>
    </tr>
  </tbody>
</table>
