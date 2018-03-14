using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TrapTrigger : MonoBehaviour 
{
	public GameObject BoxFixed;
	public GameObject BoxExploded;
	public ParticleSystem DustFall;
	public ParticleSystem DustGround;
	public int TrapDamage = 5;
	public static int TrapDamageForScript;

	public float TimerTrap = 1f;
	// Use this for initialization
	void Start () 
	{
		TrapDamageForScript = TrapDamage;
	}
	
	void OnTriggerEnter(Collider col)
	{
		if (col.gameObject.layer == LayerMask.NameToLayer("Player"))
		{
			StartCoroutine(TrapTimer(TimerTrap));
		}	
	}

	IEnumerator TrapTimer(float timer)
	{
		DustFall.Play();
		yield return new WaitForSeconds(timer);
		BoxFixed.SetActive(false);
		BoxExploded.SetActive(true);
		yield return new WaitForSeconds(0.5f);
		DustGround.Play();
		Destroy(gameObject);
	}

	/*
		faire decandre le fixed et switch au moment ou il tourche le joueur
		faire un petit shake avant de tomber
		faire vibrer la mannette au moment du DustFall Particle play
		add un capsule collider surr le player pour pas que ça passe à travers lui	
	 */
}
