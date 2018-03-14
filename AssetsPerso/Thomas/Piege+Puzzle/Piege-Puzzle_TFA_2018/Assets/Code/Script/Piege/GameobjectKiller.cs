using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameobjectKiller : MonoBehaviour 
{
	void Start () 
	{
		Destroy(gameObject,Random.Range(2.0f,4.0f));
	}
	
	void OnTriggerEnter(Collider col)
	{
		
	}
}
