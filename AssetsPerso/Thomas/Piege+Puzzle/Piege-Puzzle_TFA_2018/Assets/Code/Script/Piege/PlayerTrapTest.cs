using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerTrapTest : MonoBehaviour 
{
	public int Health = 100;

	// Use this for initialization
	void Start () 
	{
		
	}
	
	// Update is called once per frame
	void Update () 
	{
		Debug.Log(Health);
	}

	void OnTriggerEnter(Collider col)
	{
		if (col.gameObject.layer == LayerMask.NameToLayer("Trap"))
	        Health -= TrapTrigger.TrapDamageForScript;
	}
}
