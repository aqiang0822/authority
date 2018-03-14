package org.aptech.shiro.authority.pojo;

import java.io.Serializable;

public class SysRole implements Serializable {
	private static final long serialVersionUID = -3861407496725829870L;

	private Integer id;
	
	private String name;
	
	private Integer available;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getAvailable() {
		return available;
	}

	public void setAvailable(Integer available) {
		this.available = available;
	}

	@Override
	public String toString() {
		return "SysRole [id=" + id + ", name=" + name + ", available=" + available + "]";
	}
	
	
}
