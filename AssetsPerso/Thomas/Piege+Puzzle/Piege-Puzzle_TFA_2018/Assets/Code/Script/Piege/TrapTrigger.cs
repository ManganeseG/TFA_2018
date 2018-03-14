using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TrapTrigger : MonoBehaviour 
{
	public GameObject BoxFixed;
	public GameObject BoxExploded;
	public ParticleSystem GravelFall;
	public int NumberArray;
	public int TrapDamage = 5;
	public static int TrapDamageForScript;
	// Use this for initialization
	void Start () 
	{
		TrapDamageForScript = TrapDamage;
	}
	
	// Update is called once per frame
	void Update () 
	{
		
	}

	void OnTriggerEnter(Collider col)
	{
		if (col.gameObject.layer == LayerMask.NameToLayer("Player"))
		{
			BoxFixed.SetActive(false);
			BoxExploded.SetActive(true);
			GravelFall.Stop();
		}
	}
}
