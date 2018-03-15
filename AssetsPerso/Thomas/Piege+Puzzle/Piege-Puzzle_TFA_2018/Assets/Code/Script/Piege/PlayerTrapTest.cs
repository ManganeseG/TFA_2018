using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerTrapTest : MonoBehaviour 
{
	public int Health = 100;

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
