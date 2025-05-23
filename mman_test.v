module mmap

import os

fn test_mmap_file() {
	file_path := @FILE
	mut minfo := mmap_file(file_path)!
	defer {
		minfo.close()
	}

	assert minfo.fd.fd != 0
	assert minfo.addr != 0
	assert minfo.fsize == os.file_size(file_path)
	assert minfo.data.data == minfo.addr
	assert u64(minfo.data.len) == minfo.fsize

	data := os.read_file(file_path)!
	assert minfo.data == data.bytes()
}

fn test_to_byte_array() {
	mut minfo := mmap_file(@FILE)!
	defer {
		minfo.close()
	}

	x := 'module mmap'.bytes()
	assert minfo.vbytes()[..x.len] == x
}

fn test_to_string() {
	mut minfo := mmap_file(@FILE)!
	defer {
		minfo.close()
	}

	assert minfo.bytestr().starts_with('module mmap')
}
