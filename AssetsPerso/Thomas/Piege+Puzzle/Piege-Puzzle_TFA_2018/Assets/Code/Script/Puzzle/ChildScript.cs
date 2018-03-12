using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChildScript : MonoBehaviour 
{
	private Renderer renderer;
	public Material material;

	void Start()
	{
		renderer = GetComponentInChildren<Renderer>();
	}

	void OnTriggerEnter(Collider col)
	{
		renderer.material = material;
	}
}
