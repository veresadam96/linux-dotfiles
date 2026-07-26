local M = {}

M.config = function(capabilities)
	local user_home = os.getenv("HOME")
	local java_home = user_home .. "/.local/share/nvim/java"
	local jdtls_home = java_home .. "/jdtls-1.57.0"
	local java_debug_home = java_home .. "/java-debug-0.53.1"
	local spring_boot_home = java_home .. "/spring-boot-tools"
	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

	local bundles = {
		vim.fn.glob(java_debug_home .. "/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar")
	}
	vim.list_extend(bundles, vim.fn.glob(spring_boot_home .. "/*.jar", true, true))

	return {
		capabilities = capabilities,
		cmd = {
			"/usr/lib/jvm/java-21-openjdk/bin/java",
			"-Declipse.application=org.eclipse.jdt.ls.core.id1",
			"-Dosgi.bundles.defaultStartLevel=4",
			"-Declipse.product=org.eclipse.jdt.ls.core.product",
			"-Dlog.protocol=true",
			"-Dlog.level=ALL",
			"-javaagent:" .. vim.fn.glob(java_home .. "/lombok*.jar"),
			"-Xmx2g",
			"--add-modules=ALL-SYSTEM",
			"--add-opens", "java.base/java.util=ALL-UNNAMED",
			"--add-opens", "java.base/java.lang=ALL-UNNAMED",
			"-jar", vim.fn.glob(jdtls_home .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
			"-configuration", jdtls_home .. "/config_linux",
			"-data", java_home .. "/workspaces/" .. project_name,
		},
		root_dir = vim.fs.root(0, { ".git", ".svn", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
		init_options = {
			bundles = bundles,
			extendedClientCapabilities = {
				classFileContentsSupport = true,
				generateToStringPromptSupport = true,
				hashCodeEqualsPromptSupport = true,
				advancedExtractRefactoringSupport = true,
				advancedOrganizeImportsSupport = true,
				generateConstructorsPromptSupport = true,
				generateDelegateMethodsPromptSupport = true,
				moveRefactoringSupport = true,
				overrideMethodsPromptSupport = true,
				executeClientCommandSupport = true,
				inferSelectionSupport = {
					"extractMethod",
					"extractVariable",
					"extractConstant",
					"extractVariableAllOccurrence"
				},
			},
		},
		settings = {
			java = {
				configuration = {
					runtimes = {
						{
							name = "JavaSE-1.8",
							path = "/usr/lib/jvm/java-8-openjdk"
						},
						{
							name = "JavaSE-11",
							path = "/usr/lib/jvm/java-11-openjdk"
						},
						{
							name = "JavaSE-17",
							path = "/usr/lib/jvm/java-17-openjdk"
						},
						{
							name = "JavaSE-21",
							path = "/usr/lib/jvm/java-21-openjdk"
						}
					},
					--disable autobuild on class change (when building from external cli command)
					updateBuildConfiguration = "disabled",
				},
				maven = {
					downloadSources = true,
				},
				gradle = {
					wrapper = {
						enabled = true,
					},
					gradleWrapperEnabled = true,
					gradleVersion = nil,
				},
				import = {
					gradle = {
						enabled = true,
						wrapper = {
							enabled = true,
						},
						home = "",
					},
				},
			},
		}
	}
end

local function jdtls_buf_keymaps(bufnr)
	local jdtls = require("jdtls")
	local opts = { buffer = bufnr, noremap = true }
	vim.keymap.set("n", "<leader>oi", jdtls.organize_imports, opts)
	vim.keymap.set("n", "<leader>ev", jdtls.extract_variable, opts)
	vim.keymap.set("n", "<leader>ec", jdtls.extract_constant, opts)
	vim.keymap.set("v", "<leader>em", function() jdtls.extract_method(true) end, opts)
	vim.keymap.set("n", "<leader>tc", jdtls.test_class, opts)
	vim.keymap.set("n", "<leader>tm", jdtls.test_nearest_method, opts)
end

function M.setup(capabilities)
	vim.api.nvim_create_autocmd("FileType", {
		desc = "Start jdtls for Java buffers",
		group = vim.api.nvim_create_augroup("jdtls-start", { clear = true }),
		pattern = "java",
		callback = function(event)
			require("jdtls").start_or_attach(M.config(capabilities))
			jdtls_buf_keymaps(event.buf)
		end,
	})
end

function M.buf_attach_client(bufnr, client_id)
	local bufname = vim.api.nvim_buf_get_name(bufnr)
	if vim.startswith(bufname, 'jdt://') then
		if vim.api.nvim_buf_is_loaded(bufnr) then
			return vim.lsp.buf_attach_client(bufnr, client_id)
		end
		--idk what this is
		local altbuf = vim.fn.bufnr("#", -1)
		if altbuf and altbuf > 0 then
			return vim.lsp.buf_attach_client(bufnr, client_id)
		end
	elseif vim.startswith(vim.uri_from_bufnr(bufnr), "file://") then
		return vim.lsp.buf_attach_client(bufnr, client_id)
	end
	print('No active LSP client found to use for document')
end

function M.open_classfile(fname)
	local uri = vim.uri_from_fname(fname)
	local is_jdt_uri = vim.startswith(fname, "jdt://")
	local is_file_uri = vim.startswith(uri, "file://")
	assert(is_jdt_uri or is_file_uri, "Wrong URI for jdtls decompilation: " .. (is_jdt_uri and fname or uri))

	local buf = vim.api.nvim_get_current_buf()
	vim.bo[buf].modifiable = true
	vim.bo[buf].swapfile = false
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].filetype = "java"

	local client
	vim.wait(5000, function()
		client = vim.lsp.get_clients({ name = "jdtls" })[1]
		return client ~= nil
	end)
	assert(client, "Must have a jdtls client to load .class file or jdt:// uri")

	local content
	local function handler(err, result)
		assert(not err, vim.inspect(err))
		content = result
		local normalized = string.gsub(result, "\r\n", "\n")
		local source_lines = vim.split(normalized, "\n", { plain = true })
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, source_lines)
		vim.bo[buf].modifiable = false
		M.buf_attach_client(buf, client.id)
	end

	if is_jdt_uri then
		local params = { uri = fname }
		client:request("java/classFileContents", params, handler, buf)
	elseif is_file_uri then
		local command = { command = "java.decompile", arguments = { uri } }
		client:request("workspace/executeCommand", command, handler, buf)
	end
	vim.wait(500, function() return content ~= nil end)
end

vim.api.nvim_create_autocmd("BufReadCmd", {
	desc = "Decompile classes",
	group = vim.api.nvim_create_augroup("vim-lsp-jdtls-class-decompile", { clear = true }),
	pattern = { "jdt://*", "*.class" },
	callback = function()
		M.open_classfile(vim.fn.expand("<amatch>"))
	end
})

vim.api.nvim_create_autocmd("BufReadPost", {
	desc = "Java class template",
	group = vim.api.nvim_create_augroup("java-templates", { clear = true }),
	pattern = "*.java",
	callback = function()
		local utils = require("utils")
		if utils.nvim.is_buffer_empty(0) then
			local class = vim.fn.expand("%:t:r")
			local package = vim.fn.expand("%:h")
				:gsub(".*src/main/java/", "")
				:gsub("/", ".")
			vim.api.nvim_put({
				"package " .. package .. ";",
				"",
				"public class " .. class .. " {",
				"",
				"}",
			}, "l", false, true)
		end
	end
})

return M
