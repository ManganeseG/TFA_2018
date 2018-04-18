using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChildScript : MonoBehaviour 
{
	private Renderer rend;
	public Material material;

	void Start()
	{
		rend = GetComponentInChildren<Renderer>();
	}

	void OnTriggerEnter(Collider col)
	{
		if(col.tag == "PuzzleElement")
		rend.material = material;
	}
}
