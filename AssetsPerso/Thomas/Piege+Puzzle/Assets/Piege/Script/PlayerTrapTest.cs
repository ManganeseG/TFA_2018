using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerTrapTest : MonoBehaviour 
{
	void OnTriggerEnter(Collider col)
	{
		if (col.gameObject.layer == LayerMask.NameToLayer("Trap"))
		{
			HealthBar.Current.TakeDamage(TrapTrigger.TrapDamageForScript);
		}
	}
}
