-- C / C++ specific functions

local function get_basename()
    return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
end

local function is_cpp_source()
    local filename = get_basename()
    if filename:match("c" .. "$") or filename:match("cpp" .. "$") then
        return true
    end
    return false
end

local function is_cpp_header()
    local filename = get_basename()
    if filename:match("h" .. "$") or filename:match("hpp" .. "$") then
        return true
    end
    return false
end

local function create_header_label()
    local filename = get_basename()
    local ret = filename
    ret = string.upper(ret)
    ret = string.gsub(ret, "%.", "_")
    return "__" .. ret .. "__"
end

local function has_header_guard()
    local firstline = vim.api.nvim_buf_get_lines(0,0,1,false)[1]
    return firstline:match("#ifndef " .. create_header_label())
end

local function cpp_header_guard()
    local header_label = create_header_label()
    if not is_cpp_header() then
        print(get_basename() .. " is not a C/C++ header.")
        return
    end
    if has_header_guard() then
        print("Header guard detected. Aborting.")
        return
    end
    local macro_lines = {
        "#ifndef " .. header_label,
        "#define " .. header_label,
        "", "", "", "#endif ", ""
    }
    vim.api.nvim_buf_set_text(0, 0, 0, 0, 0, macro_lines)
    vim.api.nvim_feedkeys("3k", "n", true)
end

vim.keymap.set("n", "<leader>hg", cpp_header_guard, { desc = "Add include header guards." })

